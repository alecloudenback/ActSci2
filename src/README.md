## ActSci2

This is a Work-In-Progress replacement for both [MortalityTables.jl](https://github.com/alecloudenback/MortalityTables.jl) and [ActuarialScience.jl](https://github.com/alecloudenback/ActuarialScience.jl)

### Some Batteries Included

Comes with some tables built in via [mort.SOA.org](https://mort.soa.org) and by using [you agree to their terms](https://mort.soa.org/TermsOfUse.aspx).

Not all tables have been tested that they work by default, though I have not encountered issues with any of the the VBT/CSO/other usual tables.

Included:
```
2001 VBT
2001 CSO
1980 CSO
1980 CET
```

[Click here to see the full list of tables included.](BundledTables.md)



### Adding more tables

To add more tables for your use, download the `.xml` (aka the (`Xtbml` format)[https://mort.soa.org/About.aspx]) version of the table from [mort.SOA.org](https://mort.soa.org) and place it in the directory the package is installed in. This is usually `~user/.julia/packages/MortalityTables/[changing hash value]/src/tables/`. *Note: updating the package may remove your existing tables. Make a backup before updating your packages*

After placing packages in the folder above, restart Julia and the should be discoverable when you run `mt.Tables()`
