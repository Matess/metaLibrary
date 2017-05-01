declare namespace file = "http://expath.org/ns/file";
declare function local:createHTML($xmlDOC as node()*) {
<html>
    <head>
        <title>Images</title>
    </head>
    <body>
    {   for $i in $xmlDOC
        where $i/@format!='Unrecognized image file format'
        return <div>
                <img style="float:left" width="{150}" height="{150}" src="{$i/@url}"/>
                <table style="height:150" border="3">
                 <tr bgcolor="#00FF00">
                     <th style="text-align:left">Metadata</th>
                     <th style="text-align:left">Value</th>
                 </tr>
                 <tr>
                     <td>Width</td>
                     <td>{$i/Width|$i//PixelXDimension}</td>
                 </tr>
                 <tr>
                     <td>Height</td>
                     <td>{$i/Height|$i//PixelYDimension}</td>
                 </tr>
                 <tr>
                     <td>Make</td>
                     <td>{$i/Make}</td>
                 </tr>
                 <tr>
                     <td>Model</td>
                     <td>{$i/Model}</td>
                 </tr>
                </table>
               </div>
    }
    </body>
        </html>
};
local:createHTML(doc("images.xml")/Images/Image)