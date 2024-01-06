import type { HttpContextContract } from '@ioc:Adonis/Core/HttpContext'
import User from "App/Models/User";

export default class UsersController {
    public async getUserById({ params, response } : HttpContextContract) {
        const user = await User.findOrFail(params.id);
        if (user) {
            return response.ok(user);
        }
        return response.notFound();
    }

    public async togglePlace({ params, request, response } : HttpContextContract) {
        const user = await User.findOrFail(params.id);
        const { placeId } = request.body();
        user.placeId = user.placeId === placeId ? null : placeId;
        await user.save();
        return response.noContent();
    }
}
