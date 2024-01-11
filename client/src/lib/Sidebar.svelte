<script lang="ts">
	import { page } from '$app/stores';

	const pages = [
		{ name: 'Utilisateurs', path: '/users' },
		{ name: 'Lieux', path: '/places' }
	];
</script>

<div class="h-full transition-transform duration-200 bg-primary rounded-r-md p-4 w-1/6">
	<ul>
		{#each pages as { name, path }}
			<li>
				<a
					class="text-white hover:bg-neutral duration-200 rounded-md p-4 block"
					class:bg-neutral={path === $page.route.id}
					href={path}
				>
					{name}
				</a>
			</li>
		{/each}
	</ul>
</div>
