<script lang="ts">
	import type { Field } from '$lib/types/field';

	export let title: string;
	export let fields: Field[];
	export let item: any;
	export let onSubmit: () => void;
	export let onClose: () => void;

	let modal: HTMLDialogElement;

	export function showModal() {
		modal.showModal();
	}

	export function close() {
		modal.close();
	}
</script>

<dialog class="modal" bind:this={modal}>
	<div class="modal-box">
		<form method="dialog">
			<button class="btn btn-sm btn-circle btn-ghost absolute right-2 top-2" on:click={onClose}
				>✕</button
			>
		</form>
		<h3 class="font-bold text-lg">{title}</h3>
		<form on:submit|preventDefault={onSubmit}>
			{#each fields as field}
				<div class="flex flex-col">
					<label class="label" for={field.name}>{field.label}</label>
					<input
						type="text"
						placeholder={field.label}
						id={field.name}
						class="input input-bordered w-full max-w-xs"
						bind:value={item[field.name]}
					/>
				</div>
			{/each}
			<div class="modal-action">
				<button class="btn btn-primary" type="submit">Confirmer</button>
			</div>
		</form>
	</div>
</dialog>
