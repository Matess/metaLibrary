declare namespace image = "https://github.com/Matess/xsltLib";
declare namespace bin = "http://expath.org/ns/binary";
declare namespace file = "http://expath.org/ns/file";

declare function image:checkJFIF($url as xs:string) as xs:boolean
{
    if (bin:find(file:read-binary($url), 0, bin:hex('4A464946')) > 0) then
        true()
    else
        false()
};

declare function image:checkEXIF($url as xs:string) as xs:boolean
{
    if (bin:find(file:read-binary($url), 0, bin:hex('45786966')) > 0) then
        true()
    else
        false()
};

declare function image:getMetadata($tag as xs:integer, $value) as element()
{
    switch ($tag)
        case 0
            return
                <GPSVersionIF>{$value}</GPSVersionIF>
        
        case 1
            return
                <GPSLatitudeRef>{$value}</GPSLatitudeRef>
        
        case 2
            return
                <GPSLatitude>{$value}</GPSLatitude>
        
        case 3
            return
                <GPSLongitudeRef>{$value}</GPSLongitudeRef>
        
        case 4
            return
                <GPSLongitude>{$value}</GPSLongitude>
        
        case 5
            return
                <GPSAltitudeRef>{$value}</GPSAltitudeRef>
        
        case 6
            return
                <GPSAltitude>{$value}</GPSAltitude>
        
        case 7
            return
                <GPSTimeStamp>{$value}</GPSTimeStamp>
        
        case 18
            return
                <GPSMapDatum>{$value}</GPSMapDatum>
        
        case 27
            return
                <GPSProcessingMethod>{$value}</GPSProcessingMethod>
        
        case 29
            return
                <GPSDateStamp>{$value}</GPSDateStamp>
        
        case 259
            return
                <Compression>{$value}</Compression>
        
        case 271
            return
                <Make>{$value}</Make>
        
        case 272
            return
                <Model>{$value}</Model>
        
        case 274
            return
                <Orientation>{$value}</Orientation>
        
        case 282
            return
                <XResolution>{$value}</XResolution>
        
        case 283
            return
                <YResolution>{$value}</YResolution>
        
        case 296
            return
                <ResolutionUnit>{$value}</ResolutionUnit>
        
        case 305
            return
                <Software>{$value}</Software>
        
        case 306
            return
                <DateTime>{$value}</DateTime>
        
        case 513
            return
                <JPEGInterchangeFormat>{$value}</JPEGInterchangeFormat>
        
        case 514
            return
                <JPEGInterchangeFormatLength>{$value}</JPEGInterchangeFormatLength>
        
        case 531
            return
                <YCbCrPositioning>{$value}</YCbCrPositioning>
        
        case 33434
            return
                <ExposureTime>{$value}</ExposureTime>
        
        case 33437
            return
                <FNumber>{$value}</FNumber>
        
        case 34665
            return
                <ExifIFDPointer>{$value}</ExifIFDPointer>
        
        case 34853
            return
                <GPSInfoIFDPointer>{$value}</GPSInfoIFDPointer>
        
        case 34855
            return
                <ISOSpeedRatings>{$value}</ISOSpeedRatings>
        
        case 36864
            return
                <ExifVersion>{$value}</ExifVersion>
        
        case 36867
            return
                <DateTimeOriginal>{$value}</DateTimeOriginal>
        
        case 36868
            return
                <DateTimeDigitalized>{$value}</DateTimeDigitalized>
        
        case 37121
            return
                <ComponentsConfiguration>{$value}</ComponentsConfiguration>
        
        case 37122
            return
                <CompressedBitsPerPixel>{$value}</CompressedBitsPerPixel>
        
        case 37377
            return
                <ShutterSpeedValue>{$value}</ShutterSpeedValue>
        
        case 37378
            return
                <ApertureValue>{$value}</ApertureValue>
        
        case 37380
            return
                <ExposureBiasValue>{$value}</ExposureBiasValue>
        
        case 37381
            return
                <MaxApertureValue>{$value}</MaxApertureValue>
        
        case 37383
            return
                <MeteringMode>{$value}</MeteringMode>
        
        case 37385
            return
                <Flash>{$value}</Flash>
        
        case 37386
            return
                <FocalLength>{$value}</FocalLength>
        
        case 37510
            return
                <UserComment>{$value}</UserComment>
        
        case 40960
            return
                <FlashpixVersion>{$value}</FlashpixVersion>
        
        case 40961
            return
                <ColorSpace>{$value}</ColorSpace>
        
        case 40962
            return
                <PixelXDimension>{$value}</PixelXDimension>
        
        case 40963
            return
                <PixelYDimension>{$value}</PixelYDimension>
        
        case 40964
            return
                <RelatedSoundFile>{$value}</RelatedSoundFile>
        
        case 40965
            return
                <InteroperabilityIFDPointer>{$value}</InteroperabilityIFDPointer>
        
        case 41486
            return
                <FocalPlaneXResolution>{$value}</FocalPlaneXResolution>
        
        case 41487
            return
                <FocalPlaneYResolution>{$value}</FocalPlaneYResolution>
        
        case 41488
            return
                <FocalPlaneResolutionUnit>{$value}</FocalPlaneResolutionUnit>
        
        case 41495
            return
                <SensingMethod>{$value}</SensingMethod>
        
        case 41728
            return
                <FileSource>{$value}</FileSource>
        
        case 41985
            return
                <CustomRendered>{$value}</CustomRendered>
        
        case 41986
            return
                <ExposureMode>{$value}</ExposureMode>
        
        case 41987
            return
                <WhiteBalance>{$value}</WhiteBalance>
        
        case 41988
            return
                <DigitalZoomRatio>{$value}</DigitalZoomRatio>
        
        case 41990
            return
                <SceneCaptureType>{$value}</SceneCaptureType>
        default return
            <MetaTagUnknown>{$value}</MetaTagUnknown>
};

declare function image:findMetadata($binary as xs:base64Binary, $endian as xs:string, $off as xs:integer, $offValue as xs:integer) as element()+
{
    let $numOfTags := bin:unpack-unsigned-integer($binary, $off + $offValue, 2, $endian)
    let $nextIFD := bin:unpack-unsigned-integer($binary, $off + $offValue + $numOfTags * 12 + 2, 4, $endian)
    
    let $out :=
    if($nextIFD != 0) then
    <JPEG>
        <NthIFD>{image:findMetadata($binary,$endian,$off,$nextIFD)}</NthIFD>
        <Data>{image:printMetadata($binary, $endian, 0, $numOfTags, $off + $offValue + 2)}</Data></JPEG>
    else
        <Data>{image:printMetadata($binary, $endian, 0, $numOfTags, $off + $offValue + 2)}</Data>
    return $out
        
};

declare function image:findAll($url as xs:string) as element()+
{
    let $binary := file:read-binary($url)
    let $format := image:getImageFormat($url)
    
    let $res :=
    if($format = 'JPEG') then
        let $endian := image:getEndian($url)
        let $res := 
        if($endian = 'least-significant-first') then
            let $off := bin:find($binary, 0, bin:hex('08000000'))-4
            let $res := image:findMetadata($binary,$endian,$off,8)
            
            let $pos := bin:find($binary, 0, bin:hex('69870400'))
            let $offValue := bin:unpack-unsigned-integer($binary,$pos + 8,4,'least-significant-first')
            let $res2 := image:findMetadata($binary,$endian,$off,$offValue)
            
            let $pos := bin:find($binary, 0, bin:hex('25880400'))
            let $offValue := bin:unpack-unsigned-integer($binary,$pos + 8,4,'least-significant-first')
            let $res3 := image:findMetadata($binary,$endian,$off,$offValue)

            return $res | $res2 | $res3
            
           (: let $res :=
            if ($pos > 0) then
              let $offValue := bin:unpack-unsigned-integer($binary,$pos + 8,4,'least-significant-first')
                let $res2 := image:findMetadata($binary,$endian,$off,$offValue)
                return $res | $res2

            else
            ()
            return $res:)
        else
            let $off := bin:find($binary, 0, bin:hex('00000008'))-4
            let $res := image:findMetadata($binary,$endian,$off,8)
            
            let $pos := bin:find($binary, 0, bin:hex('87690004'))
            let $offValue := bin:unpack-unsigned-integer($binary,$pos + 8,4,'most-significant-first')
            let $res2 := image:findMetadata($binary,$endian,$off,$offValue)
            
            let $pos := bin:find($binary, 0, bin:hex('88250004'))
            let $offValue := bin:unpack-unsigned-integer($binary,$pos + 8,4,'most-significant-first')
            let $res3 := image:findMetadata($binary,$endian,$off,$offValue)
            
            return $res | $res2 | $res3
        return $res
    else if($format = 'PNG') then
    image:readPNG($binary)
    else if($format = 'GIF') then
    image:readGIF($binary)
    else
    xs:string("ERROR: Only JPEG/PNG/GIF image format is currently supported!")
    return $res
};

declare function image:printMetadata($binary as xs:base64Binary, $endian as xs:string, $i as xs:integer, $numOfTags as xs:integer, $location as xs:integer) as element()+
{
    for $c in (0 to $numOfTags - 1)
    return
        image:readExifMetadata($binary, $c, $location, $endian)
};

declare function image:readExifMetadata($binary as xs:base64Binary, $tagOff as xs:integer, $location as xs:integer, $endian as xs:string) as element()+
{
    
    let $metaTag := bin:unpack-unsigned-integer($binary, $location + $tagOff * 12, 2, $endian)
    let $metaType := bin:unpack-unsigned-integer($binary, $location + $tagOff * 12 + 2, 2, $endian)
    let $metaLength :=
    if ($metaType != 5) then
        bin:unpack-unsigned-integer($binary, $location + $tagOff * 12 + 4, 4, $endian)
    else
        bin:unpack-unsigned-integer($binary, $location + $tagOff * 12 + 4, 4, $endian) * 8
    let $metaOffset :=
    if ($metaLength < 5 and $metaType != 5) then
        $location + $tagOff * 12 + 8
    else
        if ($metaLength < 2 and $metaType = 5) then
            $location + $tagOff * 12 + 8
        else
            bin:unpack-unsigned-integer($binary, $location + $tagOff * 12 + 8, 4, $endian) + 30
    
    let $metadata :=
    
    if ($metaType = 1) then
        let $value := bin:unpack-unsigned-integer($binary, $metaOffset, 1, $endian)
        return
            image:getMetadata($metaTag, $value)
    else
        if ($metaType = 2) then
            let $value := bin:decode-string($binary, 'UTF-8', $metaOffset, $metaLength)
            return
                image:getMetadata($metaTag, $value)
        else
            if ($metaType = 3) then
                let $value := bin:unpack-unsigned-integer($binary, $metaOffset, 2, $endian)
                return
                    image:getMetadata($metaTag, $value)
            else
                let $value := bin:unpack-unsigned-integer($binary, $metaOffset, 4, $endian)
                return
                    image:getMetadata($metaTag, $value)
    return
        $metadata
};

declare function image:isPNG($url as xs:string) as xs:boolean
{
    if (bin:find(file:read-binary($url), 0, bin:hex('504e470d0a')) = 1) then
        true()
    else
        false()
};

declare function image:isGIF($url as xs:string) as xs:boolean
{
    if (bin:find(file:read-binary($url), 0, bin:hex('4946383761')) = 1 or bin:find(file:read-binary($url), 0, bin:hex('4946383961')) = 1) then
        true()
    else
        false()
};

declare function image:isJPEG($url as xs:string) as xs:boolean
{
    if (bin:find(file:read-binary($url), 0, bin:hex('D8FFDB')) = 1 or bin:find(file:read-binary($url), 0, bin:hex('D8FFE0')) = 1 or bin:find(file:read-binary($url), 0, bin:hex('D8FFE1')) = 1) then
        true()
    else
        false()
};

declare function image:getImageFormat($url as xs:string) as xs:string
{
    let $png := image:isPNG($url)
    let $gif := image:isGIF($url)
    let $jpeg := image:isJPEG($url)
    
    let $res :=
    if ($png = true()) then
        xs:string("PNG")
    else
        if ($gif = true()) then
            xs:string("GIF")
        else
            if ($jpeg = true()) then
                xs:string("JPEG")
            else
                xs:string("Unrecognized image file format")
    return
        $res
};

declare function image:getEndian($url as xs:string) as xs:string
{
    if (empty(bin:find(file:read-binary($url), 0, bin:hex('49492a00')))) then
        xs:string('most-significant-first')
    else
        xs:string('least-significant-first')
};

declare function image:readPNG($binary as xs:base64Binary) as element()
{
    let $headerPos := bin:find($binary, 0, bin:hex('49484452'))
    
    return
        <PNG>
            <Width>{bin:unpack-unsigned-integer($binary, $headerPos + 4, 4, 'most-significant-first')}</Width>
            <Height>{bin:unpack-unsigned-integer($binary, $headerPos + 8, 4, 'most-significant-first')}</Height>
            <BitDepth>{bin:unpack-unsigned-integer($binary, $headerPos + 12, 1, 'most-significant-first')}</BitDepth>
            <ColourType>{bin:unpack-unsigned-integer($binary, $headerPos + 13, 1, 'most-significant-first')}</ColourType>
            <CompressionMethod>{bin:unpack-unsigned-integer($binary, $headerPos + 14, 1, 'most-significant-first')}</CompressionMethod>
            <FilterMethod>{bin:unpack-unsigned-integer($binary, $headerPos + 15, 1, 'most-significant-first')}</FilterMethod>
            <InterlaceMethod>{bin:unpack-unsigned-integer($binary, $headerPos + 16, 1, 'most-significant-first')}</InterlaceMethod>
        </PNG>
};

declare function image:readGIF($binary as xs:base64Binary) as element()
{
    let $p1 := bin:find($binary, 0, bin:hex('4946383761'))
    let $p2 := bin:find($binary, 0, bin:hex('4946383961'))
    
    let $res :=
    if ($p1 > 0) then
        <GIF87A>
            <GIFVersion>87a</GIFVersion>
            <Width>{bin:unpack-unsigned-integer($binary, $p1 + 5, 2, 'least-significant-first')}</Width>
            <Height>{bin:unpack-unsigned-integer($binary, $p1 + 7, 2, 'least-significant-first')}</Height>
            <BackgroundColorIndex>{bin:unpack-unsigned-integer($binary, $p1 + 10, 1, 'least-significant-first')}</BackgroundColorIndex>
            <PixelAspectRatio>{bin:unpack-unsigned-integer($binary, $p1 + 11, 1, 'least-significant-first')}</PixelAspectRatio>
        </GIF87A>
    else
        <GIF89A>
            <GIFVersion>87a</GIFVersion>
            <Width>{bin:unpack-unsigned-integer($binary, $p2 + 5, 2, 'least-significant-first')}</Width>
            <Height>{bin:unpack-unsigned-integer($binary, $p2 + 7, 2, 'least-significant-first')}</Height>
            <BackgroundColorIndex>{bin:unpack-unsigned-integer($binary, $p2 + 10, 1, 'least-significant-first')}</BackgroundColorIndex>
            <PixelAspectRatio>{bin:unpack-unsigned-integer($binary, $p2 + 11, 1, 'least-significant-first')}</PixelAspectRatio>
        </GIF89A>
    return
        $res
};


image:getEndian("F:\exif.jpg"),

(:image:getMetadata(1, "exif"),
image:findMetadata(file:read-binary("F:\Users\Matess\Google Drive\BC_stuff\exif.jpg"), 'most-significant-first', 30, 8)
:)
image:findAll("F:\exif.jpg")
