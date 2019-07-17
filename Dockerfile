FROM einstore/swift:5.1-bionic as builder

WORKDIR /app
COPY . /app

ARG CONFIGURATION="release"

RUN swift build --configuration ${CONFIGURATION} --product systemator

# ------------------------------------------------------------------------------

FROM einstore/swift:5.1-bionic

ARG CONFIGURATION="release"

WORKDIR /app
COPY --from=builder /app/.build/${CONFIGURATION}/systemator /app

EXPOSE 8080

ENTRYPOINT ["/app/systemator"]
CMD ["serve", "--hostname", "0.0.0.0", "--port", "8080"]
