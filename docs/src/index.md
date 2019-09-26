# Home

## Overview

CatmullClark.jl is a Julia graphics package for 3D surface smoothing using the Catmull-Clark subdivision algorithm.


## Introduction

The package gereally requires Makie, though if Makie is not used for graphical display,
the module GeomtryTypes (for Point3f0 3D point arithmetic) is all that actually is used.

You may install the package from Github in the usual way, or to install the current #master copy:

    using Pkg
    Pkg.add("http://github.com/wherrera10/CatmullClark.jl")
    
## Contents

```@contents
Pages = ["index.md", "examples.md", "reference.md", "devnotes.md"]
```
