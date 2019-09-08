.PHONY: all
all: zeebe

.PHONY: start-zeebe
start-zeebe:
	ZEEBE_DEMO_VERSION=0.20.0 docker-compose up -d zeebe-0 zeebe-1 zeebe-2 gateway

.PHONY: gateway
gateway:
	ZEEBE_DEMO_VERSION=0.20.0 docker-compose up -d gateway

.PHONY: grafana
grafana:
	-docker-compose up -d prometheus grafana

.PHONY: clean-zeebe
clean-zeebe:
	docker-compose stop zeebe-0 zeebe-1 zeebe-2;
	docker-compose rm -f zeebe-0 zeebe-1 zeebe-2;

.PHONY: clean
clean:
	-docker-compose down -v

.PHONY: status
status:
	docker-compose exec gateway zbctl status

.PHONY: logs
logs:
	docker-compose logs -f
