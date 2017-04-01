<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:test="http://test.com"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:file="http://expath.org/ns/file"
  xmlns:bin="http://expath.org/ns/binary" version="2.0">
  <xsl:function name="test:getSize">
    <xsl:param name="url" as="xs:string"/>
    <xsl:variable name="binary"
      select="file:read-binary($url)"
      as="xs:base64Binary"/>
    <xsl:variable name="location" select="bin:find($binary, 0, bin:hex('FFC0'))"/>
    <xsl:value-of select="bin:unpack-unsigned-integer($binary,$location+5,2,'most-significant-first')"/>,
    <xsl:value-of select="bin:unpack-unsigned-integer($binary,$location+7,2,'most-significant-first')"/>,
    <xsl:value-of select="bin:unpack-unsigned-integer($binary,$location+9,2,'most-significant-first')"/>,
    <xsl:value-of select="bin:unpack-unsigned-integer($binary,$location+11,2,'most-significant-first')"/>
  </xsl:function>
  
  <xsl:function name="test:checkJFIF">
    <xsl:param name="url" as="xs:string"/>
    <xsl:variable name="binary"
      select="file:read-binary($url)"
      as="xs:base64Binary"/>
    <xsl:variable name="pos" select="bin:find($binary, 0, bin:hex('4A464946'))"/>
    <xsl:choose>
      <xsl:when test="$pos != 0">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="test:checkEXIF">
    <xsl:param name="url" as="xs:string"/>
    <xsl:variable name="binary"
      select="file:read-binary($url)"
      as="xs:base64Binary"/>
    <xsl:variable name="pos" select="bin:find($binary, 0, bin:hex('45786966'))"/>
    <xsl:choose>
      <xsl:when test="$pos != 0">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="test:findSMTHING">
    <xsl:param name="url" as="xs:string"/>
    <xsl:param name="tagOff" as="xs:integer"/>
    <xsl:variable name="binary"
      select="file:read-binary($url)"
      as="xs:base64Binary"/>
    <xsl:variable name="zeroIFDoff" select="bin:find($binary, 0, bin:hex('00000008'))-4"/>
    <xsl:variable name="location" select="bin:find($binary, 0, bin:hex('00000008'))+6"/>
    <xsl:variable name="numOfTags" select="bin:unpack-unsigned-integer($binary,$location - 2,2,'most-significant-first')"/>
    <xsl:variable name="metaTag" select="bin:unpack-unsigned-integer($binary,$location+$tagOff,2,'most-significant-first')"/>
    <xsl:variable name="metaType" select="bin:unpack-unsigned-integer($binary,$location+$tagOff+2,2,'most-significant-first')"/>
    <xsl:variable name="metaLength" select="bin:unpack-unsigned-integer($binary,$location+$tagOff+4,4,'most-significant-first')"/>
    <xsl:variable name="metaOffset" as="xs:integer">
     <xsl:choose>
       <xsl:when test="$metaLength &lt; 5 and $metaTag != 34665 and $metaTag != 34853"><xsl:value-of select="$location+$tagOff+8"/></xsl:when>
       <xsl:otherwise><xsl:value-of select="bin:unpack-unsigned-integer($binary,$location+$tagOff+8,4,'most-significant-first')+$zeroIFDoff"/></xsl:otherwise>
     </xsl:choose>
    </xsl:variable>
    
    <!--<xsl:value-of select="test:findExifIFDOff($binary,$zeroIFDoff)"/>-->
    
    <xsl:value-of select="'Loc:',$location+$tagOff,'$numOfTags:',$numOfTags,'$metaTag:',$metaTag,'$metaType:',$metaType,'$metaLength:',$metaLength,'$metaOffset:',$metaOffset"/>
<!--    <xsl:value-of select="bin:part($binary,$location+12,$location+16)"/>-->
    <xsl:choose>
      <xsl:when test="$metaType = 2"><!--STRING-->
        <xsl:variable name="value" select="bin:decode-string($binary,'UTF-8',$metaOffset,$metaLength)"/>
<!--        <xsl:value-of select="bin:part($binary,$metaOffset + 30,$metaLength)"/>-->
        <xsl:value-of select="test:getMetadata($metaTag,$value)"/>
      </xsl:when>
      <xsl:when test="$metaType = 3"><!--SHORT A 16-bit (2-byte) unsigned integer-->
        IntegerShort:<xsl:variable name="value" select="bin:unpack-unsigned-integer($binary,$metaOffset,2,'most-significant-first')"/>
        <xsl:value-of select="test:getMetadata($metaTag,$value)"/>
      </xsl:when>
      <xsl:when test="$metaType = 4"><!--LONG A 32-bit (4-byte) unsigned integer-->
        IntegerLong:<xsl:variable name="value" select="bin:unpack-unsigned-integer($binary,$metaOffset,4,'most-significant-first')"/>
        <xsl:value-of select="test:getMetadata($metaTag,$value)"/>
      </xsl:when>
      <xsl:when test="$metaType = 5"><!--RATIONAL Two LONGs-->
        IntegerRational:<xsl:variable name="value" select="bin:unpack-unsigned-integer($binary,$metaOffset,4,'most-significant-first')"/>
        <xsl:value-of select="test:getMetadata($metaTag,$value)"/>
      </xsl:when>
      
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="test:getMetadata">
    <xsl:param name="tag" as="xs:integer"/>
    <xsl:param name="value"/>
    <xsl:choose>
      <xsl:when test="$tag = 0">
        GPSVersionIF:<xsl:if test="$value = 2"><xsl:value-of select="xs:string('2200')"/></xsl:if>
      </xsl:when>
      <xsl:when test="$tag = 1">
        GPSLatitudeRef:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 2">
        GPSLatitude:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 3">
        GPSLongitudeRef:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 4">
        GPSLongitude:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 5">
        GPSAltitudeRef:<xsl:choose>
          <xsl:when test="$value = 0"><xsl:value-of select="xs:string('AboveSeaLevel')"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="xs:string('BelowSeaLevel')"/></xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$tag = 6">
        GPSAltitude:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 7">
        GPSTimeStamp:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 18">
        GPSMapDatum:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 27">
        GPSProcessingMethod:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 29">
        GPSDateStamp:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 259">
        Compression:<xsl:value-of select="xs:string('JPEGCompression')"/>
      </xsl:when>
      <xsl:when test="$tag = 271">
        Make:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 272">
        Model:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 274">
        Orientation:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 282">
        XResolution:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 283">
        YResolution:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 296">
        ResolutionUnit:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 305">
        Software:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 306">
        DateTime:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 513">
        JPEGInterchangeFormat:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 514">
        JPEGInterchangeFormatLength:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 531">
        YCbCrPositioning:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 33434">
        ExposureTime:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 33437">
        FNumber:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 34665">
        Exif IFD Pointer:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 34853">
        GPS Info IFD Pointer:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 34855">
        ISOSpeedRatings:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 36864">
        ExifVersion:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 36867">
        DateTimeOriginal:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 36868">
        DateTimeDigitalized:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 37121">
        ComponentsConfiguration:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 37122">
        CompressedBitsPerPixel:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 37377">
        ShutterSpeedValue:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 37378">
        ApertureValue:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 37380">
        ExposureBiasValue:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 37381">
        MaxApertureValue:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 37383">
        MeteringMode:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 37385">
        Flash(TODO page 36):<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 37386">
        FocalLength:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 37510">
        UserComment:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 40960">
        FlashpixVersion:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 40961">
        ColorSpace:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 40962">
        PixelXDimension:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 40963">
        PixelYDimension:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 40964">
        RelatedSoundFile:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 40965">
        Interoperability IFD Pointer:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 41486">
        FocalPlaneXResolution:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 41487">
        FocalPlaneYResolution:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 41488">
        FocalPlaneResolutionUnit:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 41495">
        SensingMethod:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 41728">
        FileSource:<xsl:value-of select="xs:string('DSC')"/>
      </xsl:when>
      <xsl:when test="$tag = 41985">
        CustomRendered:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 41986">
        ExposureMode:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 41987">
        WhiteBalance:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 41988">
        DigitalZoomRatio:<xsl:value-of select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 41990">
        SceneCaptureType:<xsl:value-of select="$value"/>
      </xsl:when>
      
      
      <xsl:otherwise>
        MetaTag nenalezen:<xsl:value-of select="$tag,$value"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="test:getEXIFver">
    <xsl:param name="url" as="xs:string"/>
    <xsl:variable name="binary"
      select="file:read-binary($url)"
      as="xs:base64Binary"/>
    <xsl:variable name="pos" select="bin:find($binary, 0, bin:hex('90000007'))"/>
    ExifVersion:<xsl:value-of select="bin:decode-string($binary,'UTF-8',$pos+4,8)"/>
  </xsl:function>
  
  <xsl:function name="test:getMetaInfo">
    <xsl:param name="url" as="xs:string"/>
    <xsl:variable name="binary"
      select="file:read-binary($url)"
      as="xs:base64Binary"/>
    <xsl:variable name="pos" select="bin:find($binary, 0, bin:hex('00020005'))"/>
    <xsl:variable name="len" select="bin:unpack-unsigned-integer($binary,$pos + 4,4,'most-significant-first')"/>
    <xsl:variable name="off" select="bin:unpack-unsigned-integer($binary,$pos + 8,4,'most-significant-first')"/>,
    <xsl:value-of select="'pos:',$pos,'len:',$len,'off:',$off"/>,
    MetaInfo:<xsl:value-of select="bin:decode-string($binary,'ASCII',$off+30,24)"/>,
<!--    <xsl:value-of select="bin:part($binary,$pos+$off,$len*2)"/>-->
    <xsl:value-of select="bin:unpack-unsigned-integer($binary,$off+30,4,'most-significant-first')"/>
    <xsl:value-of select="bin:unpack-unsigned-integer($binary,$off+34,4,'most-significant-first')"/>
    <xsl:value-of select="bin:unpack-unsigned-integer($binary,$off+38,4,'most-significant-first')"/>
    <xsl:value-of select="bin:unpack-unsigned-integer($binary,$off+42,4,'most-significant-first')"/>
    <xsl:value-of select="bin:unpack-unsigned-integer($binary,$off+46,4,'most-significant-first')"/>
    <xsl:value-of select="bin:unpack-unsigned-integer($binary,$off+50,4,'most-significant-first')"/>
  </xsl:function>
  
  <xsl:function name="test:getWidth">
    <xsl:param name="url" as="xs:string"/>
    <xsl:variable name="binary"
      select="file:read-binary($url)"
      as="xs:base64Binary"/>
    <xsl:variable name="pos" select="bin:find($binary, 0, bin:hex('a0020004'))"/>
    PixelXDimension:<xsl:value-of select="bin:unpack-unsigned-integer($binary,$pos + 8,4,'most-significant-first')"/>
  </xsl:function>
  
  <xsl:function name="test:getHeight">
    <xsl:param name="url" as="xs:string"/>
    <xsl:variable name="binary"
      select="file:read-binary($url)"
      as="xs:base64Binary"/>
    <xsl:variable name="pos" select="bin:find($binary, 0, bin:hex('a0030004'))"/>
    PixelYDimension:<xsl:value-of select="bin:unpack-unsigned-integer($binary,$pos + 8,4,'most-significant-first')"/>
  </xsl:function>
  
  <xsl:function name="test:getColorSpace">
    <xsl:param name="url" as="xs:string"/>
    <xsl:variable name="binary"
      select="file:read-binary($url)"
      as="xs:base64Binary"/>
    <xsl:variable name="pos" select="bin:find($binary, 0, bin:hex('a0010003'))"/>
    <xsl:variable name="res" select="bin:unpack-unsigned-integer($binary,$pos + 8,2,'most-significant-first')"/>
    ColorSpace:<xsl:choose>
      <xsl:when test="$res = 1"><xsl:value-of select="xs:string('sRGB')"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="xs:string('Uncalibrated')"/></xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="test:getComponentsConfiguration">
    <xsl:param name="url" as="xs:string"/>
    <xsl:variable name="binary"
      select="file:read-binary($url)"
      as="xs:base64Binary"/>
    <xsl:variable name="pos" select="bin:find($binary, 0, bin:hex('91010007'))"/>
    <xsl:variable name="res1" select="bin:unpack-unsigned-integer($binary,$pos + 8,1,'most-significant-first')"/>
    <xsl:variable name="res2" select="bin:unpack-unsigned-integer($binary,$pos + 9,1,'most-significant-first')"/>
    <xsl:variable name="res3" select="bin:unpack-unsigned-integer($binary,$pos + 10,1,'most-significant-first')"/>
    ComponentsConfiguration:<xsl:choose>
      <xsl:when test="$res1 = 1 and $res2 = 2 and $res3 = 3"><xsl:value-of select="xs:string('[1230]')"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="xs:string('[4560]')"/></xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="test:findMetadata">
    <xsl:param name="binary" as="xs:base64Binary"/>
    <xsl:param name="endian" as="xs:string"/>
    <xsl:param name="off" as="xs:integer"/>
    <xsl:param name="offValue" as="xs:integer"/>
    <!--<xsl:variable name="pos" select="bin:find($binary, 0, bin:hex($hex))"/>
    <xsl:variable name="offValue" select="bin:unpack-unsigned-integer($binary,$pos + 8,4,'most-significant-first')"/>-->
<!--    <xsl:value-of select="bin:unpack-unsigned-integer($binary,$off + $offValue,4,'most-significant-first')"/>-->
    <xsl:variable name="numOfTags" select="bin:unpack-unsigned-integer($binary,$off + $offValue,2,$endian)"/>
    <xsl:variable name="nextIFD" select="bin:unpack-unsigned-integer($binary,$off + $offValue + $numOfTags*12 +2,4,$endian)"/>
    <xsl:value-of select="bin:unpack-unsigned-integer($binary,$off + $offValue + $numOfTags*12 +2,4,$endian),$numOfTags"/>
<!--    <xsl:value-of select="bin:unpack-unsigned-integer($binary,$nextIFD+30,2,'most-significant-first')"/>-->
    <xsl:if test="$nextIFD != 0">
<!--      <xsl:value-of select="$off,$nextIFD"/>-->
      <xsl:value-of select="test:findMetadata2($binary,$endian,$off - 8,$nextIFD)"/>
    </xsl:if>
    <xsl:value-of select="test:printMetadata($binary,$endian,0,$numOfTags,$off+$offValue+2)"/>
    --------------------------------------
  </xsl:function>
  
  <xsl:function name="test:findMetadata2">
    <xsl:param name="binary" as="xs:base64Binary"/>
    <xsl:param name="endian" as="xs:string"/>
    <xsl:param name="off" as="xs:integer"/>
    <xsl:param name="offValue" as="xs:integer"/>
    <xsl:variable name="numOfTags" select="bin:unpack-unsigned-integer($binary,$off + $offValue,2,$endian)"/>
    <xsl:value-of select="test:printMetadata($binary,$endian,0,$numOfTags,$off+$offValue+2)"/>
    --------------------------------------
  </xsl:function>
  
  <xsl:function name="test:findAll">
    <xsl:param name="url" as="xs:string"/>
    <xsl:variable name="binary"
      select="file:read-binary($url)"
      as="xs:base64Binary"/>
    <xsl:variable name="endian" select="test:getEndian($url)"/>
    <xsl:value-of select="$endian"/>
    <xsl:choose>
      <xsl:when test="$endian = 'least-significant-first'">
        <xsl:variable name="off" select="bin:find($binary, 0, bin:hex('08000000'))-4"/>
        
        <xsl:value-of select="test:findMetadata($binary,$endian,$off+8,0)"/>
        
        <xsl:variable name="pos" select="bin:find($binary, 0, bin:hex('69870400'))"/>
        <xsl:variable name="offValue" select="bin:unpack-unsigned-integer($binary,$pos + 8,4,'least-significant-first')"/>
        <xsl:value-of select="test:findMetadata($binary,$endian,$off,$offValue)"/>
        
        <!--<xsl:variable name="pos" select="bin:find($binary, 0, bin:hex('25880400'))"/>
        <xsl:variable name="offValue" select="bin:unpack-unsigned-integer($binary,$pos + 8,4,'least-significant-first')"/>
        <xsl:value-of select="test:findMetadata($binary,$endian,$off,$offValue)"/>-->
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="off" select="bin:find($binary, 0, bin:hex('00000008'))-4"/>
        
        <xsl:value-of select="test:findMetadata($binary,$endian,$off+8,0)"/>
        <xsl:variable name="pos" select="bin:find($binary, 0, bin:hex('87690004'))"/>
        <xsl:variable name="offValue" select="bin:unpack-unsigned-integer($binary,$pos + 8,4,'most-significant-first')"/>
        <xsl:value-of select="test:findMetadata($binary,$endian,$off,$offValue)"/>
        
        <xsl:variable name="pos" select="bin:find($binary, 0, bin:hex('88250004'))"/>
        <xsl:variable name="offValue" select="bin:unpack-unsigned-integer($binary,$pos + 8,4,'most-significant-first')"/>
        <xsl:value-of select="test:findMetadata($binary,$endian,$off,$offValue)"/>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:function>
  
  <xsl:function name="test:printMetadata">
    <xsl:param name="binary" as="xs:base64Binary"/>
    <xsl:param name="endian" as="xs:string"/>
    <xsl:param name="i" as="xs:integer"/>
    <xsl:param name="numOfTags" as="xs:integer"/>
    <xsl:param name="location" as="xs:integer"/>
    <xsl:value-of select="test:readExifMetadata($binary,$i,$location,$endian)"/>
    <xsl:if test="$i &lt; ($numOfTags - 1)*12"><xsl:value-of select="test:printMetadata($binary,$endian,$i+12,$numOfTags,$location)"/></xsl:if>
  </xsl:function>
  
  
  
  <xsl:function name="test:readExifMetadata">
    <xsl:param name="binary" as="xs:base64Binary"/>
    <xsl:param name="tagOff" as="xs:integer"/>
    <xsl:param name="location" as="xs:integer"/>
    <xsl:param name="endian" as="xs:string"/>
<!--    <xsl:variable name="zeroEXIFoff" select="bin:find($binary, 0, bin:hex('00000008'))-4"/>-->
    <xsl:variable name="metaTag" select="bin:unpack-unsigned-integer($binary,$location+$tagOff,2,$endian)"/>
    <xsl:variable name="metaType" select="bin:unpack-unsigned-integer($binary,$location+$tagOff+2,2,$endian)"/>
    <xsl:variable name="metaLength" as="xs:integer"> 
      <xsl:variable name="val" select="bin:unpack-unsigned-integer($binary,$location+$tagOff+4,4,$endian)"/>
      <xsl:choose>
        <xsl:when test="$metaType != 5"><xsl:value-of select="bin:unpack-unsigned-integer($binary,$location+$tagOff+4,4,$endian)"/></xsl:when>
<!--        <xsl:when test="$metaType = 5 and $val = 1"><xsl:value-of select="$val"/></xsl:when>-->
        <xsl:otherwise><xsl:value-of select="$val*8"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
      <xsl:variable name="metaOffset" as="xs:integer">
      <xsl:choose>
        <xsl:when test="$metaLength &lt; 5 and $metaType != 5 and $metaTag != 40965"><xsl:value-of select="$location+$tagOff+8"/></xsl:when>
        <xsl:when test="$metaLength &lt; 2 and $metaType = 5"><xsl:value-of select="$location+$tagOff+8"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="bin:unpack-unsigned-integer($binary,$location+$tagOff+8,4,$endian)+30"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    
<!--    <xsl:value-of select="' Loc:',$location+$tagOff,'$metaTag:',$metaTag,'$metaType:',$metaType,'$metaLength:',$metaLength,'$metaOffset:',$metaOffset"/>-->
    <!--    <xsl:value-of select="bin:part($binary,$location+12,$location+16)"/>-->
    <xsl:choose>
      <xsl:when test="$metaType = 1"><!--BYTE-->
        <xsl:variable name="value" select="bin:unpack-unsigned-integer($binary,$metaOffset,1,$endian)"/>
        <xsl:value-of select="test:getMetadata($metaTag,$value)"/>
      </xsl:when>
      <xsl:when test="$metaType = 2"><!--STRING-->
        <xsl:variable name="value" select="bin:decode-string($binary,'UTF-8',$metaOffset,$metaLength)"/>
<!--               part: <xsl:value-of select="bin:part($binary,388,$metaLength)"/>-->
        <xsl:value-of select="test:getMetadata($metaTag,$value)"/>
      </xsl:when>
      <xsl:when test="$metaType = 3"><!--SHORT A 16-bit (2-byte) unsigned integer-->
        <!--IntegerShort:--><xsl:variable name="value" select="bin:unpack-unsigned-integer($binary,$metaOffset,2,$endian)"/>
        <xsl:value-of select="test:getMetadata($metaTag,$value)"/>
      </xsl:when>
      <xsl:when test="$metaType = 4"><!--LONG A 32-bit (4-byte) unsigned integer-->
        <!--IntegerLong:--><xsl:variable name="value" select="bin:unpack-unsigned-integer($binary,$metaOffset,4,$endian)"/>
        <xsl:value-of select="test:getMetadata($metaTag,$value)"/>
      </xsl:when>
      <xsl:when test="$metaType = 5"><!--RATIONAL Two LONGs-->
        <!--IntegerRational:-->
        <xsl:choose>
        <xsl:when test="$metaTag = 2 or $metaTag = 4">
          <xsl:variable name="val1" select="string(bin:unpack-unsigned-integer($binary,$metaOffset,4,$endian))"/>
<!--          <xsl:value-of select="bin:unpack-unsigned-integer($binary,$metaOffset+4,4,'most-significant-first')"/>-->
          <xsl:variable name="val2" select="string(bin:unpack-unsigned-integer($binary,$metaOffset+8,4,$endian))"/>
<!--          <xsl:value-of select="bin:unpack-unsigned-integer($binary,$metaOffset+12,4,'most-significant-first')"/>-->
          <xsl:variable name="val3" select="bin:unpack-unsigned-integer($binary,$metaOffset+16,4,$endian)"/>
          <xsl:variable name="val4" select="bin:unpack-unsigned-integer($binary,$metaOffset+18,2,$endian)"/>
          <xsl:variable name="value" select="concat($val1,',00°',$val2,',00´',$val3,',',$val4,'´´')"/>
         
          <xsl:value-of select="test:getMetadata($metaTag,$value)"/>
        </xsl:when>
          <xsl:when test="$metaTag = 7">
            <xsl:variable name="val1" select="string(bin:unpack-unsigned-integer($binary,$metaOffset,4,$endian))"/>
            <xsl:variable name="val2" select="string(bin:unpack-unsigned-integer($binary,$metaOffset+8,4,$endian))"/>
            <xsl:variable name="val3" select="bin:unpack-unsigned-integer($binary,$metaOffset+16,4,$endian)"/>
            <xsl:variable name="value" select="concat($val1,',00:',$val2,',00:',$val3,',00´´')"/>
            <xsl:value-of select="test:getMetadata($metaTag,$value)"/>
          </xsl:when>
          <xsl:when test="$metaTag = 282 or $metaTag = 283">
            <xsl:variable name="val1" select="string(bin:unpack-unsigned-integer($binary,$metaOffset,4,$endian))"/>
            <xsl:variable name="val2" select="string(bin:unpack-unsigned-integer($binary,$metaOffset+4,4,$endian))"/>

            <xsl:variable name="value" select="concat($val1,'/',$val2)"/>
            <xsl:value-of select="test:getMetadata($metaTag,$value)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="value" select="bin:unpack-unsigned-integer($binary,$metaOffset,4,$endian)"/>
            <xsl:value-of select="test:getMetadata($metaTag,$value)"/>
          </xsl:otherwise>
        </xsl:choose>
        
      </xsl:when>
      <xsl:when test="$metaType = 7"><!--UNDEFINED-->
        <xsl:choose>  
          <xsl:when test="$metaTag = 37121">
            <xsl:variable name="val1" select="bin:unpack-unsigned-integer($binary,$metaOffset,1,$endian)"/>
            <xsl:variable name="val2" select="bin:unpack-unsigned-integer($binary,$metaOffset+1,1,$endian)"/>
            <xsl:variable name="val3" select="bin:unpack-unsigned-integer($binary,$metaOffset+2,1,$endian)"/>
            <xsl:choose>
              <xsl:when test="$val1 = 1 and $val2 = 2 and $val3 = 3">
                <xsl:variable name="value" select="xs:string('[1230]')"/>
                <xsl:value-of select="test:getMetadata($metaTag,$value)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:variable name="value" select="xs:string('[4560]')"/>
                <xsl:value-of select="test:getMetadata($metaTag,$value)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="$metaTag = 37500">
            TODO:makerNote?
          </xsl:when>
          <xsl:otherwise>
            <!--undef7:<xsl:value-of select="bin:part($binary,$metaOffset,$metaLength)"/>-->
           <xsl:variable name="value" select="bin:decode-string($binary,'UTF-8',$metaOffset,$metaLength)"/>
           <xsl:value-of select="test:getMetadata($metaTag,$value)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$metaType = 10"><!--SRATIONAL Two LONGs-->
            <xsl:variable name="value" select="bin:unpack-unsigned-integer($binary,$metaOffset,4,$endian)"/>
            <xsl:value-of select="test:getMetadata($metaTag,$value)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="xs:string('metaType not defined!'),$metaType"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="test:isPNG">
    <xsl:param name="url" as="xs:string"/>
    <xsl:variable name="binary"
      select="file:read-binary($url)"
      as="xs:base64Binary"/>
    <xsl:variable name="pos" select="bin:find($binary, 0, bin:hex('504e470d0a'))"/>
    <xsl:choose>
      <xsl:when test="$pos = 1">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="test:isGIF">
    <xsl:param name="url" as="xs:string"/>
    <xsl:variable name="binary"
      select="file:read-binary($url)"
      as="xs:base64Binary"/>
    <xsl:variable name="pos" select="bin:find($binary, 0, bin:hex('4946383761'))"/>
    <xsl:variable name="pos2" select="bin:find($binary, 0, bin:hex('4946383961'))"/>
    <xsl:choose>
      <xsl:when test="$pos = 1 or $pos2 = 1">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="test:isJPEG">
    <xsl:param name="url" as="xs:string"/>
    <xsl:variable name="binary"
      select="file:read-binary($url)"
      as="xs:base64Binary"/>
    <xsl:variable name="pos" select="bin:find($binary, 0, bin:hex('D8FFDB'))"/>
    <xsl:variable name="pos1" select="bin:find($binary, 0, bin:hex('D8FFE0'))"/>
    <xsl:variable name="pos2" select="bin:find($binary, 0, bin:hex('D8FFE1'))"/>
    
    <xsl:choose>
      <xsl:when test="$pos = 1 or $pos1 = 1 or $pos2 = 1">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="test:getImageFormat">
    <xsl:param name="url" as="xs:string"/>

    <xsl:variable name="jpeg" select="test:isJPEG($url)"/>
    <xsl:variable name="gif" select="test:isGIF($url)"/>
    <xsl:variable name="png" select="test:isPNG($url)"/>
    
    <xsl:choose>
      <xsl:when test="$jpeg = true()">
        <xsl:value-of select="xs:string('The file is JPEG format')"/>
      </xsl:when>
      <xsl:when test="$gif = true()">
        <xsl:value-of select="xs:string('The file is GIF format')"/>
      </xsl:when>
      <xsl:when test="$png = true()">
        <xsl:value-of select="xs:string('The file is PNG format')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="xs:string('Unrecognized image file format')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="test:getEndian">
    <xsl:param name="url" as="xs:string"/>
    <xsl:variable name="binary"
      select="file:read-binary($url)"
      as="xs:base64Binary"/>
    <xsl:variable name="pos" select="bin:find($binary, 0, bin:hex('49492a00'))"/>
    <!--pos:<xsl:value-of select="$pos"/>-->
    <xsl:choose>
      <xsl:when test="empty($pos)">
        <xsl:value-of select="xs:string('most-significant-first')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="xs:string('least-significant-first')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
</xsl:stylesheet>
