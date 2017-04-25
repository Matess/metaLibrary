<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:image="https://github.com/Matess/xsltLib"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:file="http://expath.org/ns/file"
  xmlns:bin="http://expath.org/ns/binary" version="2.0" exclude-result-prefixes="#all">
  
  <xsl:function name="image:checkJFIF" as="xs:boolean">
    <xsl:param name="url" as="xs:string"/>
    <xsl:variable name="binary"
      select="file:read-binary($url)"
      as="xs:base64Binary"/>
    <xsl:variable name="pos" select="bin:find($binary, 0, bin:hex('4A464946'))"/>
    <xsl:choose>
      <xsl:when test="$pos != 0">
        <xsl:sequence select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="image:checkEXIF" as="xs:boolean">
    <xsl:param name="url" as="xs:string"/>
    <xsl:variable name="binary"
      select="file:read-binary($url)"
      as="xs:base64Binary"/>
    <xsl:variable name="pos" select="bin:find($binary, 0, bin:hex('45786966'))"/>
    <xsl:choose>
      <xsl:when test="$pos != 0">
        <xsl:sequence select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="image:getMetadata">
    <xsl:param name="tag" as="xs:integer"/>
    <xsl:param name="value"/>
    <xsl:choose>
      <xsl:when test="$tag = 0">
        <GPSVersionIF><xsl:if test="$value = 2"><xsl:sequence select="xs:string('2200')"/></xsl:if></GPSVersionIF>
      </xsl:when>
      <xsl:when test="$tag = 1">
        <GPSLatitudeRef><xsl:sequence select="$value"/></GPSLatitudeRef>
      </xsl:when>
      <xsl:when test="$tag = 2">
        <GPSLatitude><xsl:sequence select="$value"/></GPSLatitude>
      </xsl:when>
      <xsl:when test="$tag = 3">
        <GPSLongitudeRef><xsl:sequence select="$value"/></GPSLongitudeRef>
      </xsl:when>
      <xsl:when test="$tag = 4">
        <GPSLongitude><xsl:sequence select="$value"/></GPSLongitude>
      </xsl:when>
      <xsl:when test="$tag = 5">
        <GPSAltitudeRef><xsl:choose>
          <xsl:when test="$value = 0"><xsl:sequence select="xs:string('AboveSeaLevel')"/></xsl:when>
          <xsl:otherwise><xsl:sequence select="xs:string('BelowSeaLevel')"/></xsl:otherwise>
        </xsl:choose></GPSAltitudeRef>
      </xsl:when>
      <xsl:when test="$tag = 6">
        <GPSAltitude><xsl:sequence select="$value"/></GPSAltitude>
      </xsl:when>
      <xsl:when test="$tag = 7">
        <GPSTimeStamp><xsl:sequence select="$value"/></GPSTimeStamp>
      </xsl:when>
      <xsl:when test="$tag = 18">
        <GPSMapDatum><xsl:sequence select="$value"/></GPSMapDatum>
      </xsl:when>
      <xsl:when test="$tag = 27">
        <GPSProcessingMethod><xsl:sequence select="$value"/></GPSProcessingMethod>
      </xsl:when>
      <xsl:when test="$tag = 29">
        <GPSDateStamp><xsl:sequence select="$value"/></GPSDateStamp>
      </xsl:when>
      <xsl:when test="$tag = 259">
        <Compression><xsl:sequence select="xs:string('JPEGCompression')"/></Compression>
      </xsl:when>
      <xsl:when test="$tag = 271">
        <Make><xsl:sequence select="$value"/></Make>
      </xsl:when>
      <xsl:when test="$tag = 272">
        <Model><xsl:sequence select="$value"/></Model>
      </xsl:when>
      <xsl:when test="$tag = 274">
        <Orientation><xsl:sequence select="$value"/></Orientation>
      </xsl:when>
      <xsl:when test="$tag = 282">
        <XResolution><xsl:sequence select="$value"/></XResolution>
      </xsl:when>
      <xsl:when test="$tag = 283">
        <YResolution><xsl:sequence select="$value"/></YResolution>
      </xsl:when>
      <xsl:when test="$tag = 296">
        <ResolutionUnit><xsl:sequence select="$value"/></ResolutionUnit>
      </xsl:when>
      <xsl:when test="$tag = 305">
        <Software><xsl:sequence select="$value"/></Software>
      </xsl:when>
      <xsl:when test="$tag = 306">
        <DateTime><xsl:sequence select="$value"/></DateTime>
      </xsl:when>
      <xsl:when test="$tag = 513">
        <JPEGInterchangeFormat><xsl:sequence select="$value"/></JPEGInterchangeFormat>
      </xsl:when>
      <xsl:when test="$tag = 514">
        <JPEGInterchangeFormatLength><xsl:sequence select="$value"/></JPEGInterchangeFormatLength>
      </xsl:when>
      <xsl:when test="$tag = 531">
        <YCbCrPositioning><xsl:sequence select="$value"/></YCbCrPositioning>
      </xsl:when>
      <xsl:when test="$tag = 33434">
        <ExposureTime><xsl:sequence select="$value"/></ExposureTime>
      </xsl:when>
      <xsl:when test="$tag = 33437">
        <FNumber><xsl:sequence select="$value"/></FNumber>
      </xsl:when>
      <xsl:when test="$tag = 34665">
        <ExifIFDPointer><xsl:sequence select="$value"/></ExifIFDPointer>
      </xsl:when>
      <xsl:when test="$tag = 34853">
        <GPSInfoIFDPointer><xsl:sequence select="$value"/></GPSInfoIFDPointer>
      </xsl:when>
      <xsl:when test="$tag = 34855">
        <ISOSpeedRatings><xsl:sequence select="$value"/></ISOSpeedRatings>
      </xsl:when>
      <xsl:when test="$tag = 36864">
        <ExifVersion><xsl:sequence select="$value"/></ExifVersion>
      </xsl:when>
      <xsl:when test="$tag = 36867">
        <DateTimeOriginal><xsl:sequence select="$value"/></DateTimeOriginal>
      </xsl:when>
      <xsl:when test="$tag = 36868">
        <DateTimeDigitalized><xsl:sequence select="$value"/></DateTimeDigitalized>
      </xsl:when>
      <xsl:when test="$tag = 37121">
        <ComponentsConfiguration><xsl:sequence select="$value"/></ComponentsConfiguration>
      </xsl:when>
      <xsl:when test="$tag = 37122">
        <CompressedBitsPerPixel><xsl:sequence select="$value"/></CompressedBitsPerPixel>
      </xsl:when>
      <xsl:when test="$tag = 37377">
        <ShutterSpeedValue><xsl:sequence select="$value"/></ShutterSpeedValue>
      </xsl:when>
      <xsl:when test="$tag = 37378">
        <ApertureValue><xsl:sequence select="$value"/></ApertureValue>
      </xsl:when>
      <xsl:when test="$tag = 37380">
        <ExposureBiasValue><xsl:sequence select="$value"/></ExposureBiasValue>
      </xsl:when>
      <xsl:when test="$tag = 37381">
        <MaxApertureValue><xsl:sequence select="$value"/></MaxApertureValue>
      </xsl:when>
      <xsl:when test="$tag = 37383">
        <MeteringMode><xsl:sequence select="$value"/></MeteringMode>
      </xsl:when>
      <xsl:when test="$tag = 37385">
        Flash(TODO page 36):<xsl:sequence select="$value"/>
      </xsl:when>
      <xsl:when test="$tag = 37386">
        <FocalLength><xsl:sequence select="$value"/></FocalLength>
      </xsl:when>
      <xsl:when test="$tag = 37510">
        <UserComment><xsl:sequence select="$value"/></UserComment>
      </xsl:when>
      <xsl:when test="$tag = 40960">
        <FlashpixVersion><xsl:sequence select="$value"/></FlashpixVersion>
      </xsl:when>
      <xsl:when test="$tag = 40961">
        <ColorSpace><xsl:sequence select="$value"/></ColorSpace>
      </xsl:when>
      <xsl:when test="$tag = 40962">
        <PixelXDimension><xsl:sequence select="$value"/></PixelXDimension>
      </xsl:when>
      <xsl:when test="$tag = 40963">
        <PixelYDimension><xsl:sequence select="$value"/></PixelYDimension>
      </xsl:when>
      <xsl:when test="$tag = 40964">
        <RelatedSoundFile><xsl:sequence select="$value"/></RelatedSoundFile>
      </xsl:when>
      <xsl:when test="$tag = 40965">
        <InteroperabilityIFDPointer><xsl:sequence select="$value"/></InteroperabilityIFDPointer>
      </xsl:when>
      <xsl:when test="$tag = 41486">
        <FocalPlaneXResolution><xsl:sequence select="$value"/></FocalPlaneXResolution>
      </xsl:when>
      <xsl:when test="$tag = 41487">
        <FocalPlaneYResolution><xsl:sequence select="$value"/></FocalPlaneYResolution>
      </xsl:when>
      <xsl:when test="$tag = 41488">
        <FocalPlaneResolutionUnit><xsl:sequence select="$value"/></FocalPlaneResolutionUnit>
      </xsl:when>
      <xsl:when test="$tag = 41495">
        <SensingMethod><xsl:sequence select="$value"/></SensingMethod>
      </xsl:when>
      <xsl:when test="$tag = 41728">
        <FileSource><xsl:sequence select="xs:string('DSC')"/></FileSource>
      </xsl:when>
      <xsl:when test="$tag = 41985">
        <CustomRendered><xsl:sequence select="$value"/></CustomRendered>
      </xsl:when>
      <xsl:when test="$tag = 41986">
        <ExposureMode><xsl:sequence select="$value"/></ExposureMode>
      </xsl:when>
      <xsl:when test="$tag = 41987">
        <WhiteBalance><xsl:sequence select="$value"/></WhiteBalance>
      </xsl:when>
      <xsl:when test="$tag = 41988">
        <DigitalZoomRatio><xsl:sequence select="$value"/></DigitalZoomRatio>
      </xsl:when>
      <xsl:when test="$tag = 41990">
        <SceneCaptureType><xsl:sequence select="$value"/></SceneCaptureType>
      </xsl:when>
      
      
      <xsl:otherwise>
        <MetaTagUnknown><xsl:sequence select="$tag,$value"/></MetaTagUnknown>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="image:findMetadata">
    <xsl:param name="binary" as="xs:base64Binary"/>
    <xsl:param name="endian" as="xs:string"/>
    <xsl:param name="off" as="xs:integer"/>
    <xsl:param name="offValue" as="xs:integer"/>

    <xsl:variable name="numOfTags" select="bin:unpack-unsigned-integer($binary,$off + $offValue,2,$endian)"/>
    <xsl:variable name="nextIFD" select="bin:unpack-unsigned-integer($binary,$off + $offValue + $numOfTags*12 +2,4,$endian)"/>

    <xsl:if test="$nextIFD != 0">
      <NthIFD>
        <xsl:sequence select="image:findMetadata($binary,$endian,$off,$nextIFD)"/>
      </NthIFD>
    </xsl:if>
    <xsl:sequence select="image:printMetadata($binary,$endian,0,$numOfTags,$off+$offValue+2)"/>

  </xsl:function>
  
  <xsl:function name="image:findAll">
    <xsl:param name="url" as="xs:string"/>
    <xsl:variable name="binary"
      select="file:read-binary($url)"
      as="xs:base64Binary"/>
    <xsl:variable name="format" select="image:getImageFormat($url)"/>
    <Image format="{$format}" url="{$url}">
    <xsl:choose>
      <xsl:when test="$format = 'JPEGExif'">
        
    <xsl:variable name="endian" select="image:getEndian($url)"/>
    <xsl:choose>
      <xsl:when test="$endian = 'least-significant-first'">
        
        <xsl:variable name="off" select="bin:find($binary, 0, bin:hex('08000000'))-4"/>
        
        <xsl:sequence select="image:findMetadata($binary,$endian,$off,8)"/>
        
        <xsl:variable name="pos" select="bin:find($binary, 0, bin:hex('69870400'))"/>
        <xsl:if test="$pos > 0">
          <xsl:variable name="offValue" select="bin:unpack-unsigned-integer($binary,$pos + 8,4,'least-significant-first')"/>
          <ExifInfo>
            <xsl:sequence select="image:findMetadata($binary,$endian,$off,$offValue)"/>
          </ExifInfo>
        </xsl:if>
        <xsl:variable name="pos" select="bin:find($binary, 0, bin:hex('25880400'))"/>
        <xsl:if test="$pos > 0">
          <xsl:variable name="offValue" select="bin:unpack-unsigned-integer($binary,$pos + 8,4,'least-significant-first')"/>
          <GPSInfo>
            <xsl:sequence select="image:findMetadata($binary,$endian,$off,$offValue)"/>
          </GPSInfo>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        
        <xsl:variable name="off" select="bin:find($binary, 0, bin:hex('00000008'))-4"/>
        <xsl:sequence select="image:findMetadata($binary,$endian,$off,8)"/>
        
        <xsl:variable name="pos" select="bin:find($binary, 0, bin:hex('87690004'))"/>
        <xsl:if test="$pos > 0">
          <xsl:variable name="offValue" select="bin:unpack-unsigned-integer($binary,$pos + 8,4,'most-significant-first')"/>
          <ExifInfo>
            <xsl:sequence select="image:findMetadata($binary,$endian,$off,$offValue)"/>
          </ExifInfo>
        </xsl:if>
        
        <xsl:variable name="pos" select="bin:find($binary, 0, bin:hex('88250004'))"/>
        <xsl:if test="$pos > 0">
          <xsl:variable name="offValue" select="bin:unpack-unsigned-integer($binary,$pos + 8,4,'most-significant-first')"/>
          <GPSInfo>
            <xsl:sequence select="image:findMetadata($binary,$endian,$off,$offValue)"/>
          </GPSInfo>
        </xsl:if>
        
      </xsl:otherwise>
    </xsl:choose>
      </xsl:when>
      <xsl:when test="$format = 'JPEG'">
        <xsl:sequence select="image:readJPEG($binary)"/>
      </xsl:when>
      <xsl:when test="$format = 'PNG'">
        <xsl:sequence select="image:readPNG($binary)"/>
      </xsl:when>
      <xsl:when test="$format = 'GIF'">
        <xsl:sequence select="image:readGIF($binary)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message terminate="no">ERROR: Only JPEG/PNG/GIF image format is currently supported!</xsl:message>
      </xsl:otherwise>
    </xsl:choose>
    </Image>
  </xsl:function>
  
  <xsl:function name="image:printMetadata">
    <xsl:param name="binary" as="xs:base64Binary"/>
    <xsl:param name="endian" as="xs:string"/>
    <xsl:param name="i" as="xs:integer"/>
    <xsl:param name="numOfTags" as="xs:integer"/>
    <xsl:param name="location" as="xs:integer"/>
    <xsl:sequence select="image:readExifMetadata($binary,$i,$location,$endian)"/>
    <xsl:if test="$i &lt; ($numOfTags - 1)*12"><xsl:sequence select="image:printMetadata($binary,$endian,$i+12,$numOfTags,$location)"/></xsl:if>
  </xsl:function>
  
  
  
  <xsl:function name="image:readExifMetadata">
    <xsl:param name="binary" as="xs:base64Binary"/>
    <xsl:param name="tagOff" as="xs:integer"/>
    <xsl:param name="location" as="xs:integer"/>
    <xsl:param name="endian" as="xs:string"/>

    <xsl:variable name="metaTag" select="bin:unpack-unsigned-integer($binary,$location+$tagOff,2,$endian)"/>
    <xsl:variable name="metaType" select="bin:unpack-unsigned-integer($binary,$location+$tagOff+2,2,$endian)"/>
    <xsl:variable name="metaLength" as="xs:integer"> 
      <xsl:variable name="val" select="bin:unpack-unsigned-integer($binary,$location+$tagOff+4,4,$endian)"/>
      <xsl:choose>
        <xsl:when test="$metaType != 5"><xsl:sequence select="bin:unpack-unsigned-integer($binary,$location+$tagOff+4,4,$endian)"/></xsl:when>
<!--        <xsl:when test="$metaType = 5 and $val = 1"><xsl:sequence select="$val"/></xsl:when>-->
        <xsl:otherwise><xsl:sequence select="$val*8"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
      <xsl:variable name="metaOffset" as="xs:integer">
      <xsl:choose>
        <xsl:when test="$metaLength &lt; 5 and $metaType != 5"><xsl:sequence select="$location+$tagOff+8"/></xsl:when>
        <xsl:when test="$metaLength &lt; 2 and $metaType = 5"><xsl:sequence select="$location+$tagOff+8"/></xsl:when>
        <xsl:otherwise><xsl:sequence select="bin:unpack-unsigned-integer($binary,$location+$tagOff+8,4,$endian)+30"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    
<!--    <xsl:sequence select="' Loc:',$location+$tagOff,'$metaTag:',$metaTag,'$metaType:',$metaType,'$metaLength:',$metaLength,'$metaOffset:',$metaOffset"/>-->

    <xsl:choose>
      <xsl:when test="$metaType = 1"><!--BYTE-->
        <xsl:variable name="value" select="bin:unpack-unsigned-integer($binary,$metaOffset,1,$endian)"/>
        <xsl:sequence select="image:getMetadata($metaTag,$value)"/>
      </xsl:when>
      <xsl:when test="$metaType = 2"><!--STRING-->
        <xsl:variable name="value" select="bin:decode-string($binary,'UTF-8',$metaOffset,$metaLength)"/>
<!--               part: <xsl:sequence select="bin:part($binary,388,$metaLength)"/>-->
        <xsl:sequence select="image:getMetadata($metaTag,$value)"/>
      </xsl:when>
      <xsl:when test="$metaType = 3"><!--SHORT A 16-bit (2-byte) unsigned integer-->
        <!--IntegerShort:--><xsl:variable name="value" select="bin:unpack-unsigned-integer($binary,$metaOffset,2,$endian)"/>
        <xsl:sequence select="image:getMetadata($metaTag,$value)"/>
      </xsl:when>
      <xsl:when test="$metaType = 4"><!--LONG A 32-bit (4-byte) unsigned integer-->
        <!--IntegerLong:--><xsl:variable name="value" select="bin:unpack-unsigned-integer($binary,$metaOffset,4,$endian)"/>
        <xsl:sequence select="image:getMetadata($metaTag,$value)"/>
      </xsl:when>
      <xsl:when test="$metaType = 5"><!--RATIONAL Two LONGs-->
        <!--IntegerRational:-->
        <xsl:choose>
        <xsl:when test="$metaTag = 2 or $metaTag = 4">
          <xsl:variable name="val1" select="string(bin:unpack-unsigned-integer($binary,$metaOffset,4,$endian))"/>
          <xsl:variable name="val2" select="string(bin:unpack-unsigned-integer($binary,$metaOffset+8,4,$endian))"/>
          <xsl:variable name="val3" select="bin:unpack-unsigned-integer($binary,$metaOffset+16,4,$endian)"/>
          <xsl:variable name="val4" select="bin:unpack-unsigned-integer($binary,$metaOffset+18,2,$endian)"/>
          <xsl:variable name="value" select="concat($val1,',00°',$val2,',00´',$val3,',',$val4,'´´')"/>
         
          <xsl:sequence select="image:getMetadata($metaTag,$value)"/>
        </xsl:when>
          <xsl:when test="$metaTag = 7">
            <xsl:variable name="val1" select="string(bin:unpack-unsigned-integer($binary,$metaOffset,4,$endian))"/>
            <xsl:variable name="val2" select="string(bin:unpack-unsigned-integer($binary,$metaOffset+8,4,$endian))"/>
            <xsl:variable name="val3" select="bin:unpack-unsigned-integer($binary,$metaOffset+16,4,$endian)"/>
            <xsl:variable name="value" select="concat($val1,',00:',$val2,',00:',$val3,',00´´')"/>
            <xsl:sequence select="image:getMetadata($metaTag,$value)"/>
          </xsl:when>
          <xsl:when test="$metaTag = 282 or $metaTag = 283">
            <xsl:variable name="val1" select="string(bin:unpack-unsigned-integer($binary,$metaOffset,4,$endian))"/>
            <xsl:variable name="val2" select="string(bin:unpack-unsigned-integer($binary,$metaOffset+4,4,$endian))"/>

            <xsl:variable name="value" select="concat($val1,'/',$val2)"/>
            <xsl:sequence select="image:getMetadata($metaTag,$value)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="value" select="bin:unpack-unsigned-integer($binary,$metaOffset,4,$endian)"/>
            <xsl:sequence select="image:getMetadata($metaTag,$value)"/>
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
                <xsl:sequence select="image:getMetadata($metaTag,$value)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:variable name="value" select="xs:string('[4560]')"/>
                <xsl:sequence select="image:getMetadata($metaTag,$value)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="$metaTag = 37500">
            TODO:makerNote?
          </xsl:when>
          <xsl:otherwise>
            <!--undef7:<xsl:sequence select="bin:part($binary,$metaOffset,$metaLength)"/>-->
           <xsl:variable name="value" select="bin:decode-string($binary,'UTF-8',$metaOffset,$metaLength)"/>
           <xsl:sequence select="image:getMetadata($metaTag,$value)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$metaType = 10"><!--SRATIONAL Two LONGs-->
            <xsl:variable name="value" select="bin:unpack-unsigned-integer($binary,$metaOffset,4,$endian)"/>
            <xsl:sequence select="image:getMetadata($metaTag,$value)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="xs:string('metaType not defined!'),$metaType"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="image:isPNG" as="xs:boolean">
    <xsl:param name="binary" as="xs:base64Binary"/>
    <xsl:variable name="pos" select="bin:find($binary, 0, bin:hex('504e470d0a'))"/>
    <xsl:choose>
      <xsl:when test="$pos = 1">
        <xsl:sequence select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="image:isGIF" as="xs:boolean">
    <xsl:param name="binary" as="xs:base64Binary"/>
    <xsl:variable name="pos" select="bin:find($binary, 0, bin:hex('4946383761'))"/>
    <xsl:variable name="pos2" select="bin:find($binary, 0, bin:hex('4946383961'))"/>
    <xsl:choose>
      <xsl:when test="$pos = 1 or $pos2 = 1">
        <xsl:sequence select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="image:isJPEG" as="xs:boolean">
    <xsl:param name="binary" as="xs:base64Binary"/>
    <xsl:variable name="pos" select="bin:find($binary, 0, bin:hex('D8FFDB'))"/>
    <xsl:variable name="pos1" select="bin:find($binary, 0, bin:hex('D8FFE0'))"/>
    <xsl:variable name="pos2" select="bin:find($binary, 0, bin:hex('D8FFE1'))"/>
    <xsl:choose>
      <xsl:when test="$pos = 1 or $pos1 = 1 or $pos2 = 1">
        <xsl:sequence select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="image:getImageFormat" as="xs:string">
    <xsl:param name="url" as="xs:string"/>
    <xsl:variable name="binary"
      select="file:read-binary($url)"
      as="xs:base64Binary"/>

    <xsl:variable name="jpeg" select="image:isJPEG($binary)"/>
    <xsl:variable name="gif" select="image:isGIF($binary)"/>
    <xsl:variable name="png" select="image:isPNG($binary)"/>
    
    <xsl:choose>
      <xsl:when test="$jpeg = true()">
        <xsl:variable name="exif" select="image:checkEXIF($url)"/>
        <xsl:choose>
          <xsl:when test="$exif = true()">
            <xsl:sequence select="xs:string('JPEGExif')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:sequence select="xs:string('JPEG')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$gif = true()">
        <xsl:sequence select="xs:string('GIF')"/>
      </xsl:when>
      <xsl:when test="$png = true()">
        <xsl:sequence select="xs:string('PNG')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="xs:string('Unrecognized image file format')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="image:getEndian" as="xs:string">
    <xsl:param name="url" as="xs:string"/>
    <xsl:variable name="binary"
      select="file:read-binary($url)"
      as="xs:base64Binary"/>
    <xsl:variable name="pos" select="bin:find($binary, 0, bin:hex('49492a00'))"/>
    <xsl:choose>
      <xsl:when test="empty($pos)">
        <xsl:sequence select="xs:string('most-significant-first')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="xs:string('least-significant-first')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="image:readPNG">
    <xsl:param name="binary" as="xs:base64Binary"/>
    <xsl:variable name="headerPos" select="bin:find($binary, 0, bin:hex('49484452'))"/>
    <Width><xsl:sequence select="bin:unpack-unsigned-integer($binary,$headerPos+4,4,'most-significant-first')"/></Width>
    <Height><xsl:sequence select="bin:unpack-unsigned-integer($binary,$headerPos+8,4,'most-significant-first')"/></Height>
    <BitDepth><xsl:sequence select="bin:unpack-unsigned-integer($binary,$headerPos+12,1,'most-significant-first')"/></BitDepth>
    <ColourType><xsl:sequence select="bin:unpack-unsigned-integer($binary,$headerPos+13,1,'most-significant-first')"/></ColourType>
    <CompressionMethod><xsl:sequence select="bin:unpack-unsigned-integer($binary,$headerPos+14,1,'most-significant-first')"/></CompressionMethod>
    <FilterMethod><xsl:sequence select="bin:unpack-unsigned-integer($binary,$headerPos+15,1,'most-significant-first')"/></FilterMethod>
    <InterlaceMethod><xsl:sequence select="bin:unpack-unsigned-integer($binary,$headerPos+16,1,'most-significant-first')"/></InterlaceMethod>
  </xsl:function>
  
  <xsl:function name="image:readGIF">
    <xsl:param name="binary" as="xs:base64Binary"/>
    <xsl:variable name="p1" select="bin:find($binary, 0, bin:hex('4946383761'))"/>
    <xsl:variable name="p2" select="bin:find($binary, 0, bin:hex('4946383961'))"/>
    <xsl:choose>
      <xsl:when test="$p1 > 0">
        <GIFVersion>87a</GIFVersion>
        <Width><xsl:sequence select="bin:unpack-unsigned-integer($binary,$p1+5,2,'least-significant-first')"/></Width>
        <Height><xsl:sequence select="bin:unpack-unsigned-integer($binary,$p1+7,2,'least-significant-first')"/></Height>
        <BackgroundColorIndex><xsl:sequence select="bin:unpack-unsigned-integer($binary,$p1+10,1,'least-significant-first')"/></BackgroundColorIndex>
        <PixelAspectRatio><xsl:sequence select="bin:unpack-unsigned-integer($binary,$p1+11,1,'least-significant-first')"/></PixelAspectRatio>
      </xsl:when>
      <xsl:otherwise>
        <GIFVersion>89a</GIFVersion>
        <Width><xsl:sequence select="bin:unpack-unsigned-integer($binary,$p2+5,2,'least-significant-first')"/></Width>
        <Height><xsl:sequence select="bin:unpack-unsigned-integer($binary,$p2+7,2,'least-significant-first')"/></Height>
        <BackgroundColorIndex><xsl:sequence select="bin:unpack-unsigned-integer($binary,$p2+10,1,'least-significant-first')"/></BackgroundColorIndex>
        <PixelAspectRatio><xsl:sequence select="bin:unpack-unsigned-integer($binary,$p2+11,1,'least-significant-first')"/></PixelAspectRatio>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="image:readJPEG">
    <xsl:param name="binary" as="xs:base64Binary"/>
    <xsl:variable name="SOF" select="bin:find($binary, 0, bin:hex('FFC0'))"/>
    <xsl:variable name="DQT" select="bin:find($binary, 0, bin:hex('FFDB'))"/>
    <xsl:choose>
      <xsl:when test="$SOF > 0">
        <BitsPerSample><xsl:sequence select="bin:unpack-unsigned-integer($binary,$SOF+4,1,'most-significant-first')"/></BitsPerSample>
        <Height><xsl:sequence select="bin:unpack-unsigned-integer($binary,$SOF+5,2,'most-significant-first')"/></Height>
        <Width><xsl:sequence select="bin:unpack-unsigned-integer($binary,$SOF+7,2,'most-significant-first')"/></Width>
        <ColorComponents><xsl:sequence select="bin:unpack-unsigned-integer($binary,$SOF+9,1,'most-significant-first')"/></ColorComponents>
    </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="DQTLen" select="bin:unpack-unsigned-integer($binary,$DQT+2,2,'most-significant-first')"/>
        <Height><xsl:sequence select="bin:unpack-unsigned-integer($binary,$DQT+$DQTLen*2+9,2,'most-significant-first')"/></Height>
        <Width><xsl:sequence select="bin:unpack-unsigned-integer($binary,$DQT+$DQTLen*2+11,2,'most-significant-first')"/></Width>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
</xsl:stylesheet>
