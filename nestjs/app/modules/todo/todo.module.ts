import { Module } from "@nestjs/common";
import { TodoController } from "./todo.controller";
import { TodoServices } from "./todo.service";

@Module({
    controllers: [TodoController],
    providers: [TodoServices],
})
export class TodoModule {}
