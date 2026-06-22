# Guide: Implementing Google Sign-In with Firebase Auth (Firebase Setup)
This guide will walk you through adding **Google Sign-In with Firebase Authentication** to the **Haajir App** using the **FlutterFire CLI** for quick configuration.

We will install the Firebase CLI using **Node.js** and **npm** (Node Package Manager). This is the most stable and reliable method on Windows systems.

---

## Lesson Plan Overview (60 Minutes)
1. **Phase 1: Node.js, npm & Firebase CLI Installation** 
2. **Phase 2: Dependencies & Native App Signatures** 
3. **Phase 3: Project Configuration with FlutterFire CLI** 

---

## Phase 1: Node.js, npm & Firebase CLI Installation

We will install Node.js (which includes npm) and use npm to globally install the Firebase CLI (`firebase-tools`).

### Step 1.1: Download and Install Node.js
1. Open your browser and navigate to the official [Node.js Downloads page](https://nodejs.org/).
2. Click and download the **LTS (Long Term Support)** Windows Installer (`.msi`).
3. Run the downloaded installer. 
4. Step through the installation wizard:
   * Accept the license agreement.
   * Keep the default installation directory.
   * **CRITICAL:** In the **Custom Setup** screen, ensure that the **"Add to PATH"** option is selected (it is selected by default).
   * Finish the installation.

### Step 1.2: Verify Node.js and npm Installation
1. Open a **new** **PowerShell** or **Command Prompt** window (restarting your terminal is necessary to load the new environment PATH variables).
2. Run the following commands to check that both Node.js and npm are installed successfully:
   ```cmd
   node --version
   npm --version
   ```
   *You should see version numbers printed (e.g. `v20.x.x` and `10.x.x`).*

### Step 1.3: Install the Firebase CLI Globally
1. Run the npm installation command to download and install the Firebase CLI:
   ```cmd
   npm install -g firebase-tools
   ```
2. Once the command finishes, verify that the CLI is accessible:
   ```cmd
   firebase --version
   ```

#### 🛠️ Troubleshooting: `firebase: command not found` or `not recognized`
If Windows says the command is not recognized, npm's global binaries directory has not been added to your PATH environment variables automatically. 
Run this command in **PowerShell** to add it permanently to your Windows User Path, then restart PowerShell:
```powershell
[Environment]::SetEnvironmentVariable("Path", [Environment]::GetEnvironmentVariable("Path", "User") + ";$env:USERPROFILE\AppData\Roaming\npm", "User")
```

### Step 1.4: Log In to Firebase
Authenticates your terminal with your Google/Firebase developer account.
1. Run the login command:
   ```cmd
   firebase login
   ```
2. A browser window will open automatically. Log in using your Google credentials.
3. Close the browser window once the terminal displays `Success! Logged in as <your-email>`.

---

## Phase 2: Dependencies & Native App Signatures

### Step 2.1: Add Flutter Dependencies
Open a terminal in your project root (`haajir`) and run:
```cmd
flutter pub add flutter_bloc google_sign_in firebase_core firebase_auth
```

### Step 2.2: Retrieve Android SHA-1 Fingerprint
Google Sign-In requires registering your debug app signature on Firebase.
1. Navigate to the `android` folder in your project:
   ```cmd
   cd android
   ```
2. Run the Gradle signing report command:
   ```cmd
   .\gradlew signingReport
   ```
3. Scroll up through the output to locate the **`debug`** variant signature block:
   ```text
   Variant: debug
   Config: debug
   Store: C:\Users\<YourUsername>\.android\debug.keystore
   Alias: androiddebugkey
   SHA-1: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX  <-- COPY THIS
   ```
4. Navigate back to the project root:
   ```cmd
   cd ..
   ```

---

## Phase 3: Project Configuration with FlutterFire CLI
### Step 3.1: Activate FlutterFire CLI
Run the following command to globally activate the FlutterFire helper package:
```cmd
dart pub global activate flutterfire_cli
```

### Step 3.2: Configure Firebase in Your App
Run the configuration wizard.
* **Standard Command:**
  ```cmd
  flutterfire configure
  ```
* **Critical Windows PATH Workaround:** If Windows throws a `"flutterfire is not recognized..."` error (due to Dart's binary folder not being in your Windows environment PATH variables), run this command instead:
  ```cmd
  dart pub global run flutterfire_cli:flutterfire configure
  ```

#### Configuration Prompts Walkthrough:
1. **Select Firebase Project:** Choose **`create a new project`** and enter a name (e.g. `haajir-app-class`).
2. **Select Platforms:** Choose platforms (use spacebar to select/deselect: **`android`**, **`ios`**, and **`web`** are selected by default). Press Enter.
3. **Wait for Registration:** The CLI will create the project, register the apps, and generate your configuration files automatically.
4. **Register SHA-1 Fingerprint:**
   Go to the [Firebase Console](https://console.firebase.google.com/), open your newly created project, navigate to **Project Settings (gear icon) > General**, select the Android app, click **Add fingerprint**, and paste the **SHA-1** key you retrieved in Step 2.2.
5. **Enable Google Sign-In:** In Firebase Console, go to **Build > Authentication > Sign-in method**, click **Google**, enable it, select a support email, and click **Save**.
