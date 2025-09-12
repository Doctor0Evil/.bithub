To extract legitimate ALN structures (e.g., `21.027`) from a string for grant verification or CMD-based compliance, use the federal ALN format, which is strictly a two-digit agency code followed by a decimal and a three-digit program code. Example ALNs include:

- **84.425** (U.S. Department of Education’s Education Stabilization Fund)
- **93.778** (U.S. Department of Health & Human Services’ Medical Assistance Program)
- **64.000** (Generic for Department of Veterans Affairs when no specific award number is available).[3][4][7][8][9]

### Example: Extracting ALNs from Mixed Input with CMD

Suppose the input string is:
```
random;21.027;text, extra93.778, some84.425E, unrelated;64.000;xyz
```

Batch script to extract legitimate ALNs:
```batch
@echo off
REM Extract all legitimate ALNs from input.txt (one line per record)

setlocal enabledelayedexpansion
for /f "tokens=*" %%l in (input.txt) do (
    REM Match XX.XXX or XX.XXXY (subprograms)
    for %%a in (%%l) do (
        echo %%a | findstr /R "^[0-9][0-9]\.[0-9][0-9][0-9][A-Z]*$" >nul
        if not errorlevel 1 echo Valid ALN found: %%a
    )
)
endlocal
```
- Aim for results like:
  - Valid ALN found: 21.027  
  - Valid ALN found: 93.778  
  - Valid ALN found: 84.425E  
  - Valid ALN found: 64.000  

### Federal ALN Format Reference
- Format: `XX.XXX` (sometimes with an additional letter for subprograms, e.g. `84.425E`)
- Source: Award letters, notices, the official SAM.gov directory.[4][7][8][3]

Always submit only these validated ALN strings to batch scripts or containment modules for further grant verification and federal reporting.[3]

[1](https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/collection_eed4474f-6861-4355-9899-1eecc5cd0229/3a0e781e-a75f-4de6-8f1f-cda37719238b/Feature-ALNAssistanceListingNumber-CFDACatalogofFederalDomesticAssistance.csv)
[2](https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/collection_eed4474f-6861-4355-9899-1eecc5cd0229/dbb97949-dcd2-4bf3-aa56-5c7e3c7fb0da/c-users-hunter-c-users-hunter-ic34wBXcR5qTseH1ZNjQjw.md)
[3](https://fmx.cpa.texas.gov/fmx/training/wbt/sefa/0108.php)
[4](https://controller.ucsf.edu/news/202108/contracts-grants-accounting/understanding-assistance-listing-number)
[5](https://www.osp.pitt.edu/news/what-assistance-listing-number)
[6](https://sam.gov/assistance-listings)
[7](https://research.arizona.edu/tags/uaccess-research-uar)
[8](https://www.nmdfa.state.nm.us/wp-content/uploads/2024/11/Where-to-Find-an-Assistance-Listing-Number.pdf)
[9](https://sam.gov/fal/92c843d6f9274e6ebfbb141b5bcd3c51/view)
[10](https://sam.gov/fal/2993037c1ec34c49843556ceea184430/view)
