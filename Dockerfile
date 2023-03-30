FROM golang:1.20 AS build

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY * ./

RUN go build -o /k8s-oidc-auth .

RUN go test ./...

#########
FROM gcr.io/distroless/base-debian11

WORKDIR /

COPY --from=build /k8s-oidc-auth /k8s-oidc-auth

USER nonroot:nonroot

ENTRYPOINT ["/k8s-oidc-auth"]