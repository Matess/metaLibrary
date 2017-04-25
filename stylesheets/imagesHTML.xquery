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
                     <th style="text-align:left">Hodnota</th>
                 </tr>
                 <tr>
                     <td>Width</td>
                     <td>{$i/Width}</td>
                 </tr>
                 <tr>
                     <td>Height</td>
                     <td>{$i/Height}</td>
                 </tr>
                 <tr>
                     <td>Format</td>
                     <td>{data($i/@format)}</td>
                 </tr>
                 <tr>
                     <td>ImageSize</td>
                     <td>{round(file:size($i/@url) div 1024)} KB</td>
                 </tr>
                 
                </table>
               </div>
    }
    </body>
        </html>
};
local:createHTML(doc("images.xml")/Images/Image)