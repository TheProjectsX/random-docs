import { IsBoolean, IsOptional, IsString } from "class-validator";

export class UpdateTodoDto {
    @IsString()
    @IsOptional()
    title: string;

    @IsString()
    @IsOptional()
    description: string;

    @IsBoolean()
    @IsOptional()
    finished: boolean;
}
