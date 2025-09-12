import { Module } from "@nestjs/common";
import { TodoModule } from "./modules/todo/todo.module";

@Module({
    imports: [TodoModule /* ...more Modules here */],
})
export class AppModule {}
