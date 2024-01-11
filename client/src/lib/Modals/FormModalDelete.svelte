<script lang="ts">
	export let title: string;
	export let content: string;
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
		<p>{content}</p>
		<div class="modal-action">
			<button class="btn btn-error" on:click={onSubmit}>Supprimer</button>
		</div>
	</div>
</dialog>
