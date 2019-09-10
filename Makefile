.PHONY: zeebe
zeebe:
	docker-compose up -d zeebe-0 zeebe-1 zeebe-2 gateway

.PHONY: gateway
gateway:
	docker-compose up -d gateway

.PHONY: grafana
grafana:
	-docker-compose up -d prometheus grafana

.PHONY: clean-zeebe
clean-zeebe:
	docker-compose stop zeebe-0 zeebe-1 zeebe-2 gateway
	docker-compose rm -f zeebe-0 zeebe-1 zeebe-2 gateway

.PHONY: clean
clean:
	-docker-compose down -v

.PHONY: starter
starter:
	-docker-compose up -d starter

.PHONY: worker
worker:
	-docker-compose up -d worker

clean-starter:
	docker-compose stop starter
	docker-compose rm -f starter

clean-worker:
	docker-compose stop worker
	docker-compose rm -f worker

.PHONY: status
status:
	docker-compose exec gateway zbctl status

.PHONY: logs
logs:
	docker-compose logs -f
