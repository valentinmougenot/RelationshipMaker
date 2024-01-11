import Drive from '@ioc:Adonis/Core/Drive'
import type { HttpContextContract } from '@ioc:Adonis/Core/HttpContext'
import User from 'App/Models/User'

export default class UsersController {
  public async getAllUsers({ response }: HttpContextContract) {
    const users = await User.all()
    return response.ok(users)
  }

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
    const { firstName, lastName, companyName, biography, avatarUrl, placeId } = request.body()
    user.firstName = firstName
    user.lastName = lastName
    user.companyName = companyName
    user.biography = biography
    user.avatarUrl = avatarUrl
    user.placeId = placeId
    await user.save()
    return response.noContent()
  }

  public async deleteUser({ params, response }: HttpContextContract) {
    const user = await User.findOrFail(params.id)
    await user.delete()
    return response.noContent()
  }

  public async togglePlace({ params, request, response }: HttpContextContract) {
    const user = await User.findOrFail(params.id)
    const { placeId } = request.body()
    user.placeId = user.placeId === placeId ? null : placeId
    await user.save()
    return response.noContent()
  }

  public async uploadAvatar({ params, request, response }: HttpContextContract) {
    const user = await User.findOrFail(params.id)
    const avatar = request.file('avatar', {
      size: '2mb',
      extnames: ['jpg', 'png', 'jpeg'],
    })
    if (avatar) {
      if (user.avatarUrl) {
        await Drive.delete(user.avatarUrl)
      }
      await avatar.moveToDisk('./avatars/')
      const url = await Drive.getUrl(`avatars/${avatar.fileName}`)
      user.avatarUrl = url
      await user.save()
      return response.ok({ avatarUrl: url })
    }
    return response.badRequest()
  }

  public async deleteAvatar({ params, response }: HttpContextContract) {
    const user = await User.findOrFail(params.id)
    if (user.avatarUrl) {
      await Drive.delete(user.avatarUrl)
      user.avatarUrl = null!
      await user.save()
      return response.noContent()
    }
    return response.badRequest()
  }
}
