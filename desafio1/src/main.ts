import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

   app.enableCors({
    origin: [
      'http://localhost:54321',  // Puerto común de Flutter Web
      'http://localhost:53589',  // Otro puerto común
      'http://localhost:59487',  // Otro puerto común
      'http://localhost:3000',   // Tu backend
      'http://127.0.0.1:54321',  // IP local
      'http://127.0.0.1:53589',
    ],
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization', 'Accept'],
    credentials: true,
  });
  
  await app.listen(process.env.PORT ?? 3000);
}
bootstrap();
