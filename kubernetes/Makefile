
create_schedule_app_secrets:
	kubectl create secret generic schedule-app-secrets --from-env-file=.env

restore_db:
	etc/restore_db.sh

run_volume_provisioner:
	./scripts/run_volume_provisioner.sh
