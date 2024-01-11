import { BaseModel, HasMany, column, hasMany } from '@ioc:Adonis/Lucid/Orm'
import User from './User'

export default class Place extends BaseModel {
  @column({ isPrimary: true, serializeAs: 'id' })
  public id: number

  @column({ serializeAs: 'name' })
  public name: string

  @column({ serializeAs: 'latitude' })
  public latitude: number

  @column({ serializeAs: 'longitude' })
  public longitude: number

  @hasMany(() => User)
  public users: HasMany<typeof User>
}
