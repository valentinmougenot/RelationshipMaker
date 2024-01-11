import { BaseModel, column } from '@ioc:Adonis/Lucid/Orm'

export default class User extends BaseModel {
  @column({ isPrimary: true, serializeAs: 'id' })
  public id: number

  @column({ serializeAs: 'firstName' })
  public firstName: string

  @column({ serializeAs: 'lastName' })
  public lastName: string

  @column({ serializeAs: 'companyName' })
  public companyName?: string

  @column({ serializeAs: 'biography' })
  public biography?: string

  @column({ serializeAs: 'avatarUrl' })
  public avatarUrl?: string

  @column({ serializeAs: 'placeId' })
  public placeId?: number
}
