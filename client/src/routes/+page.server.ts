import { redirect } from '@sveltejs/kit';
import type { PageServerLoad } from './$types';

export const load = (() => {
    redirect(308, '/users');
}) satisfies PageServerLoad;