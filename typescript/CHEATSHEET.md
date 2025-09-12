### 1. **Types**

```ts
// primitive types
let id: number = 1;
let name: string = "Rahat";
let active: boolean = true;
let tags: string[] = ["dev", "ts"];

// object type
type User = {
    id: string;
    name: string;
    email?: string; // optional
    verified: boolean;
};
```

---

### 2. **Functions**

```ts
function greet(name: string): string {
    return `Hello, ${name}`;
}

// arrow fn
const sum = (a: number, b: number): number => a + b;
```

---

### 3. **Interfaces vs Types**

```ts
interface IUser {
    id: string;
    name: string;
}

type Product = {
    id: number;
    price: number;
};
```

---

### 4. **Generics**

```ts
// Generic wrapper to make properties optional
type Partialize<T> = {
    [K in keyof T]?: T[K];
};

type User = {
    id: string;
    name: string;
    email: string;
};

type PartialUser = Partialize<User>;

const u: PartialUser = {
    id: "1",
    // name and email not required
};
```

---

### 5. **Classes**

```ts
class User {
    constructor(
        public id: string,
        public name: string,
        private password: string
    ) {}

    greet(): string {
        return `Hi, I am ${this.name}`;
    }
}
```

---

### 6. **Node Imports/Exports**

```ts
// export
export const add = (a: number, b: number) => a + b;

// import
import { add } from "./math";
```

---

### 7. **Express Example**

```ts
import express, { Request, Response, NextFunction } from "express";

const app = express();

app.get("/", (req: Request, res: Response, next: NextFunction) => {
    res.send("Hello TypeScript + Node");
});

app.listen(3000);
```
