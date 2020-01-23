# Shopping With Me - ios App
Shopping-with-me is a shopping helper app. When you want to buy a product and would like to know if it’s available or cheaper in other stores, all you need is just scanning the barcode of the product and the app will do the searching for you.

## How to install the app
1. Clone the repo `git clone https://github.com/gracexinran/capstone-shopping-with-me.git`
2. Go to the `Capstone` folder that contains the Podfile, install the dependencies by running `pod install`
3. Open the `Capstone.xcworkspace`
4. Create a new bundle ID and sign the app
5. Create a firebase project or use the existed one
6. Add an ios app to firebase project with the bundle ID
7. Download the `GoogleService-Info.plist` and add it to the project
8. Build and run the app

## How to use the app
1. Users provides a photo with a valid barcode through either the photo library or the camera.
2. The **Next** button shows up if the barcode in the photo is readable.
3. If the product’s barcode exists in the database, the app will find the product information and some merchants selling the product.
4. Users can pick an offer by clicking the **Go To Your Pick** button. It would direct the user to the webpage.
5. Users can also **Explore More** and see more results provided by Google search.


## Demo
1. Provide a photo

<img src="https://github.com/gracexinran/capstone-shopping-with-me/blob/master/gif/app-take-photo.gif?raw=true" title="take photo" width=205 height=350/>  <img src="https://github.com/gracexinran/capstone-shopping-with-me/blob/master/gif/app-upload-photo.gif?raw=true" title="upload photo" width=205 height=350/>

2. Pick an offer

<img src="https://github.com/gracexinran/capstone-shopping-with-me/blob/master/gif/app-pick-offer.gif?raw=true" title="pick offer" width=205 height=350/>

3. Explore more on Google

<img src="https://github.com/gracexinran/capstone-shopping-with-me/blob/master/gif/app-explore-more.gif?raw=true" title="explore more" width=205 height=350/>  <img src="https://github.com/gracexinran/capstone-shopping-with-me/blob/master/gif/app-load-more.gif?raw=true" title="load more" width=205 height=350/>  <img src="https://github.com/gracexinran/capstone-shopping-with-me/blob/master/gif/app-link-to-result.gif?raw=true" title="link to result" width=205 height=350/>

