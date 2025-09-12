import { Injectable, NotFoundException } from "@nestjs/common";
import { CreateTodoDto, UpdateTodoDto } from "./dto";

@Injectable()
export class TodoService {
    // Retrieve all todos for a user
    async getAllTodo(userId: string) {
        // Prisma version:
        // return await this.prismaService.todo.findMany({ where: { userId } });
        return `Fetching all todos for user: ${userId}`;
    }

    // Get a single Todo
    async getSingleTodoById(userId: string, todoId: string) {
        // Prisma version:
        // return await this.prismaService.todo.findFirst({ where: { id: todoId, userId } });
        return `Fetching todo ${todoId} for user: ${userId}`;
    }

    // Create a new Todo
    async createTodo(userId: string, body: CreateTodoDto) {
        // Prisma version:
        // body.userId = userId;
        // return await this.prismaService.todo.create({ data: body });
        return `Creating todo for user: ${userId} with data: ${JSON.stringify(
            body
        )}`;
    }

    // Update Todo
    async updateTodo(todoId: string, userId: string, body: UpdateTodoDto) {
        // Prisma version:
        // return await this.prismaService.todo.update({
        //   where: { id: todoId, userId },
        //   data: body,
        // });
        return `Updating todo ${todoId} for user: ${userId} with data: ${JSON.stringify(
            body
        )}`;
    }

    // Delete Todo
    async deleteTodo(userId: string, todoId: string) {
        // Prisma version:
        // return await this.prismaService.todo.delete({ where: { id: todoId, userId } });
        return `Deleting todo ${todoId} for user: ${userId}`;
    }
}
