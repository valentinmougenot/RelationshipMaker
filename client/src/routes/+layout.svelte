<script lang="ts">
	import '../app.css';
	import Sidebar from '$lib/Sidebar.svelte';
</script>

<div class="flex justify-start h-screen gap-4">
	<Sidebar />
	<div>
		<slot />
	</div>
</div>
