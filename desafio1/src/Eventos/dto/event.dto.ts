import { 
  IsString, 
  IsNotEmpty, 
  IsDate, 
  IsOptional, 
  IsNumber, 
  MinLength, 
  Min 
} from 'class-validator';
import { Type } from 'class-transformer';

export class CreateEventDto {
  @IsString()
  @IsNotEmpty({ message: 'El título es requerido' })
  @MinLength(5, { message: 'El título debe tener al menos 5 caracteres' })
  title: string;

  @IsString()
  @IsNotEmpty({ message: 'La descripción es requerida' })
  @MinLength(10, { message: 'La descripción debe tener al menos 10 caracteres' })
  description: string;

  @IsDate()
  @Type(() => Date)
  date: Date;

  @IsString()
  @IsNotEmpty({ message: 'La ubicación es requerida' })
  location: string;

  @IsOptional()
  @IsNumber()
  lat?: number;

  @IsOptional()
  @IsNumber()
  lng?: number;

  @IsOptional()
  imageData?: Buffer;

  @IsOptional()
  @IsString()
  imageType?: string;

  @IsOptional()
  @IsString()
  imageName?: string;
}