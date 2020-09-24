# View3DObjectAndSnapshot
# ARKit

View3DObjectAndSnapshot is an iOS Application which uses ARKit. In this user can add 3D object by tapping on the screen and take the snapshot and get access to the user current postion.

Demo Video Link: **[View3DObjectAndSnapshot - ARKit iOS](https://www.youtube.com/watch?v=nQVSrd1SBYo&feature=youtu.be)**

#### Features:
This app has following major features:
1. 3D Oject can be placed by tapping on the screen
2. Snapshots can be taken
3. User Postions and snapshots will be saved to the coredata
4. Snapshots can be viewed after saving
5. Dot has been added on the x(red),z(blue) postions.
6. Snapshots can be deleted from the coredata
7. Ojbects can be cleared

#### System Architecture:
This application has been developed on Xcode IDE. Xcode is used for creating native iOS, watchOS, tvOS applications. Xcode does not generate the code for any application. Developer has to design the screens first and then connect the code with the design.

**Views:** (UI View Elements)
1. **Main.storyboard** (where I have the UI Views designed)

**Controllers:** (View Controllers)
1. ViewController (Where I handled everyhting. Adding 3D-object, getting postions x,z)

**File Naming Conventions:**
* **VC** are ViewControllers

**Variable Naming Conventions:**

As Swift guidelines state that **"Names of types and protocols are UpperCamelCase. Everything else is lowerCamelCase."**

App 3D-Objects are placed in **art.scnassets** folder.

### Cocoapods:

View3DObjectAndSnapshot uses a open source 3rd Party Library for better user experience:

* [RappleProgressHUD](https://github.com/rjeprasad/RappleProgressHUD) - Custom Activity Indicator(Loader/Spinner)

### Support:
In case of any errors or app crashes please email me at:

Hassan Shahid ( [hassan.shahid94@yahoo.com](hassan.shahid94@yahoo.com) )

----


**Last Updated: 21.09.2020**
