# Redux Toolkit Store Setup Guide

## Folder Structure

```
src/
└── store/
    ├── app/
    │   └── store.js
    └── features/
        └── user/
            └── userSlice.js
```

---

## 🛠️ Installation

```bash
npm install @reduxjs/toolkit react-redux
```

---

## 1. Create a Slice

**`src/store/features/user/userSlice.js`**

```js
import { createSlice } from "@reduxjs/toolkit";

const featureSlice = createSlice({
    name: "feature",
    initialState: {},
    reducers: {
        yourAction: (state, action) => {
            // reducer logic here
        },
    },
});

export const { yourAction } = featureSlice.actions;
export default featureSlice.reducer;
```

---

## 2. Create the Store

**`src/store/app/store.js`**

```js
import { configureStore } from "@reduxjs/toolkit";
import userReducer from "../features/user/userSlice";

export const store = configureStore({
    reducer: {
        user: userReducer,
    },
});
```

---

## 3. Provide the Store

Wrap your app with `Provider`:

```js
import { StrictMode } from "react";
import ReactDOM from 'react-dom/client';
import { Provider } from 'react-redux';
import { store } from './store/app/store';
import App from './App';

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
    <StrictMode>
        <Provider store={store}>
            <App />
        </Provider>
    <StrictMode/>
);
```

## NOTE:

-   In RTK Query You can use `baseApi` and inject endpoints in the `baseApiSlice`. This way, it is easier to use cause of the same API URL.
-   You should not inject same named endpoint in the same `baseApiSlice` as the `baseApiSlice` is working like a Object
