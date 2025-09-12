import {
    Body,
    Controller,
    Delete,
    Get,
    NotFoundException,
    Param,
    Post,
    Put,
} from "@nestjs/common";
import { TodoService } from "./todo.service";
import { CreateTodoDto, UpdateTodoDto } from "./dto";

@Controller("todo")
export class TodoController {
    constructor(private todoService: TodoService) {}

    @Get()
    async getAll(@Param("userId") userId: string) {
        return this.todoService.getAllTodo(userId);
    }

    @Get(":id")
    async getById(@Param("id") id: string, @Param("userId") userId: string) {
        const todo = await this.todoService.getSingleTodoById(userId, id);
        if (!todo) throw new NotFoundException("Todo Not Found");
        return todo;
    }

    @Post()
    async create(@Body() data: CreateTodoDto, @Param("userId") userId: string) {
        return this.todoService.createTodo(userId, data);
    }

    @Put(":id")
    async update(
        @Param("id") id: string,
        @Body() data: UpdateTodoDto,
        @Param("userId") userId: string
    ) {
        return this.todoService.updateTodo(id, userId, data);
    }

    @Delete(":id")
    async delete(@Param("id") id: string, @Param("userId") userId: string) {
        return this.todoService.deleteTodo(userId, id);
    }
}
