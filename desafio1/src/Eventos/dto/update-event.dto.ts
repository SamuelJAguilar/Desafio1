import { 
  IsString, 
  IsOptional, 
  IsDate, 
  IsNumber, 
  MinLength 
} from 'class-validator';
import { Type } from 'class-transformer';

export class UpdateEventDto {
  @IsOptional()
  @IsString()
  @MinLength(5)
  title?: string;

  @IsOptional()
  @IsString()
  @MinLength(10)
  description?: string;

  @IsOptional()
  @IsDate()
  @Type(() => Date)
  date?: Date;

  @IsOptional()
  @IsString()
  location?: string;

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