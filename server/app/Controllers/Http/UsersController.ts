import type { HttpContextContract } from '@ioc:Adonis/Core/HttpContext'
import User from 'App/Models/User'

export default class UsersController {
  public async getUserById({ params, response }: HttpContextContract) {
    const user = await User.findOrFail(params.id)
    if (user) {
      return response.ok(user)
    }
    return response.notFound()
  }

  public async createUser({ request, response }: HttpContextContract) {
    const { firstName, lastName, companyName, biography, avatarUrl } = request.body()
    const user = await User.create({ firstName, lastName, companyName, biography, avatarUrl })
    return response.created(user)
  }

  public async updateUser({ params, request, response }: HttpContextContract) {
    const user = await User.findOrFail(params.id)
    const { firstName, lastName, companyName, biography, avatarUrl } = request.body()
    user.firstName = firstName
    user.lastName = lastName
    user.companyName = companyName
    user.biography = biography
    user.avatarUrl = avatarUrl
    await user.save()
    return response.noContent()
  }

  public async togglePlace({ params, request, response }: HttpContextContract) {
    const user = await User.findOrFail(params.id)
    const { placeId } = request.body()
    user.placeId = user.placeId === placeId ? null : placeId
    await user.save()
    return response.noContent()
  }
}
