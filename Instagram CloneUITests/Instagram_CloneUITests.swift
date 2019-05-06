import XCTest

class Instagram_CloneUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoginButtonIsDisabledAtLaunch() {
        let loginButton = XCUIApplication().buttons["Log in"]
        XCTAssertFalse(loginButton.isEnabled);
    }
    
    func testLoginButtonIsDisabledIfUsernameEmpty() {
        let app = XCUIApplication()
        app.textFields["Phone number, username or email"].tap()
        app.keyboards.keys["a"].tap()
        let loginButton = XCUIApplication().buttons["Log in"]
        XCTAssertFalse(loginButton.isEnabled);
    }

    func testLoginButtonIsDisabledIfPasswordEmpty() {
        let app = XCUIApplication()
        app.secureTextFields["Password"].tap()
        app.keyboards.keys["a"].tap()
        let loginButton = XCUIApplication().buttons["Log in"]
        XCTAssertFalse(loginButton.isEnabled);
    }
    
    func testLoginButtonIsEnabledIfFillUsernameAndPassword() {
        let app = XCUIApplication()
        app.textFields["Phone number, username or email"].tap()
        app.keyboards.keys["a"].tap()
        app.secureTextFields["Password"].tap()
        app.keyboards.keys["a"].tap()
        let loginButton = XCUIApplication().buttons["Log in"]
        XCTAssertTrue(loginButton.isEnabled);
    }
    
    func testTapBackgroundHideKeyboard() {
        let app = XCUIApplication()
        app.textFields["Phone number, username or email"].tap()
        XCTAssertGreaterThan(app.keyboards.count, 0)
        app.otherElements.containing(.staticText, identifier:"Instagram").element.tap()
        XCTAssertEqual(0, app.keyboards.count)
        app.secureTextFields["Password"].tap()
        XCTAssertGreaterThan(app.keyboards.count, 0)
        app.otherElements.containing(.staticText, identifier:"Instagram").element.tap()
        XCTAssertEqual(0, app.keyboards.count)
    }
    
    func testKeyboardNextFocusPasswordField() {
        
        let app = XCUIApplication()
        app.textFields["Phone number, username or email"].tap()
        app.buttons["Next:"].tap()
        app.keys["a"].tap()
        app.keys["a"].tap()
        app.keys["a"].tap()
        let passwordTextField = app.secureTextFields["Password"]
        XCTAssertEqual(3, (passwordTextField.value as! String).count)
    }
    
    func testKeyboardHasDoneWhenPasswordInFocus() {
        let app = XCUIApplication()
        app.secureTextFields["Password"].tap()
        app.buttons["Done"].tap()
    }
}
