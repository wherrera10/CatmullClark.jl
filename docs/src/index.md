# Home

![CatmullClark](./assets/catmullclark.png)

## Overview

The Catmull-Clark


## Introduction

The package gereally requires Makie, though if Makie is not used for graphicd display,
the module GeomtryTypes (for Point3f0 3D point arithmetic) is all that is used.


You can install the package by:



```@raw html
<table>
    <tr>
        <th>Package</th>
        <th>Functions</th>
        <th>Displaying Results</th>
    </tr>
    <tr>
        <td><code>CatmullClark</code></td>
        <td><code>catmullclarkstep</code></td>
        <td><code>catmullclark</code></td>
        <td><code>drawfaces</code></td>
        <td><code>drawfaces!</code></td>
        <td><code>displaycallback</code></td>
        <td><code>getscene</code></td>
        <td><code>setscene<code></td>
    </tr>
</table>
```

## Notes

### How many iterations?

	Generally, two iterations is enough to provide a nicely rounded figure
	if starting from one with sharp corners. If a high resolution smoothing
	is desired, up to 5 or more iterations may be likely required. More 
	iterations will take longer rendering times before the output is ready.


### Choice of display method

	The usual choice for OpenGL grahing in Julia is currently Makie. Other
	methods include ______________________, 
	

