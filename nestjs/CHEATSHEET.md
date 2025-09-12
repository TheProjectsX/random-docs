## **NestJS CLI Commands**

```bash
# Create a new project
nest new project-name

# Generate modules, controllers, services for users feature
nest generate module users       # or nest g mo users
nest generate controller users   # or nest g co users
nest generate service users      # or nest g s users

# Build the project
npm run build

# Start the project
npm run start       # dev mode
npm run start:dev   # watch mode
npm run start:prod  # production

# Test
npm run test
npm run test:watch
```

---

## **Decorators Quick Reference**

```ts
@Controller('path')      # Define a controller
@Get(), @Post(), @Put(), @Delete()   # HTTP methods
@Param('id')            # Get route param
@Body()                 # Get request body
@Query('q')             # Get query param
@UseGuards(AuthGuard)   # Add guards
@Injectable()           # Mark class as injectable
```

---

## **Common Patterns**

```ts
// Injecting a service
constructor(private service: FeatureService) {}

// Using DTOs
@Post()
create(@Body() dto: CreateDto) {
  return this.service.create(dto);
}

// Exception handling
throw new NotFoundException('Not found');
```
