# Agent Instructions

**Follow these rules when generating code:**

## General Principles

* Follow **Clean Code** standards. Prefer **descriptive, long function names** over abbreviations.
* Use CamelCase for code and Object properties.
* Use kebab-case for filenames.
* Use Snake_case for constants, environment variables and http payloads.
* Use **Single Responsibility**: each function/class/module does one thing well.
* Organize domain logic in **Services** (business rules), **Repositories** (local data access), **Mappers** (between Services, API (remote data access) and Repositories).
* Services work with DTOs (Data Transfer Objects) to encapsulate data and reduce coupling.
* Services use Mappers to convert between DTOs and domain entities in Repositories and APIs.
* Repositories handle data persistence and retrieval.
* Keep **Services** and **Repositories stateless**. Pass all needed data as parameters; avoid hidden state.
* We working in OOP/FP hybrid style using **plain objects and functions**. Avoid classes unless modeling domain entities.
* **Never return `undefined`** from the “strict” API. For each operation, provide **two variants**:

  * A base function that **may return `undefined`**.
  * A strict wrapper with the suffix **`OrFail`** that **throws an error** if the base function returns `undefined`.
* Follow **Domain-Driven Design (DDD)** principles:

  * This library models ONE specific business domain.
  * Organize code by **domain concepts** (not by technical layers).
  * Core business logic lives in the **domain layer**, isolated from frameworks.
  * Application services orchestrate domain behavior; repositories provide persistence for aggregates.
* Organize domain logic in **Services** (business/application rules), **Repositories** (local data access) and Api (for remote data access).

## Naming & Structure

* Functions should be **verb-heavy and explicit** about inputs/outputs, e.g. `findUserByIdFromPrimaryStore`.
* Strict wrappers must be named `...OrFail`.
* Repository method names must describe the exact query or persistence intent, e.g. `findUserById`, `saveNewUserRecord`, `deleteUserById`.
* Service method names should reflect business use cases, e.g. `registerUserWithEmailVerification`, `deactivateUserAndRevokeSessions`.

## Error & Result Handling

* Base variant: return a concrete type **or** `undefined` (never `null`).
* Strict variant: call the base method and **throw** a descriptive `Error` (or domain-specific error) if result is `undefined`.
* Do **not** mix return-based and exception-based flows in one function.

## Statelessness

* No shared mutable state, no caches inside services/repositories/api (unless explicitly injected as dependencies).
* All configuration and collaborators are **passed in** (constructor or parameters).

## Domain-Driven Design (DDD) Structure

* **Entities:** Represent unique domain objects with identity and lifecycle (e.g., `User`, `Order`, `Invoice`).
* **Value Objects:** Immutable, equality-based types that describe domain data (e.g., `EmailAddress`, `Money`).
* **Aggregates:** Clusters of entities and value objects that form a consistency boundary. Access them through an **aggregate root** only.
* **Domain Services:** Contain business logic that doesn’t naturally belong to a specific entity or value object.
* **Application Services:** Coordinate domain operations and orchestrate workflows.
* **Repositories:** Abstract persistence and retrieval of aggregates.
* **Domain Events:** Represent significant occurrences in the domain (e.g., `UserRegistered`, `OrderCancelled`).

## Repository Layer (Data Access)

* Purpose: isolate persistence details (DB, HTTP, file system).
* Methods are **thin**: translate between domain types and storage schemas.
* No business logic here.

## Service Layer (Business Logic)

* Purpose: orchestrate repositories and enforce business rules.
* Compose repository calls; keep side effects explicit via parameters and return values.

## API Layer

* Purpose: communication layer for remote systems.
* Take over their types if possible

## Testing Principles

* The codebase should strive for **close to 100% test coverage**.
* Use **Jest** as the testing framework.
* To mock dependencies, use mock<T>() from 'jest-mock-extended'.
* Tests should be **deterministic** and **isolated**. No reliance on external systems or state.
* Follow the **Arrange-Act-Assert (AAA)** pattern in tests for clarity.
* Each test should focus on **one behavior** or **one aspect** of the functionality.
* Use **descriptive test names** that explain the scenario and expected outcome.
* Do not write tests for *.types.ts files.
* Create Mocks in *.mocks.ts files instead of inline.
* A good architecture is one that enables **excellent testability**:

  * Stateless functions and dependency injection make unit testing simple.
  * Avoid static dependencies or hidden state that makes tests brittle.
  * Each service and repository function must be easily mockable or testable in isolation.
  * Business rules should be covered with **clear, deterministic unit tests**.
* Tests should cover both:

  * The **base variant** (returning `undefined` when not found).
  * The **strict variant** (throwing an error when not found).

## Documentation instructions

- All documentation is in README.md. It contains:
  - Summary description of the library
  - Raw Listing of features
  - Installation
  - Some basic usage examples
  - Refer to API in /docs/api

## Project Structure

### Root Directory

- [README.md](mdc:readme.md) - Project documentation and usage instructions
- [/src](mdc:src) - Source code directory
- [/src/<ENTITY_SERVICE_NAME>.service.ts](mdc:src%2Fservice_name.service.ts) - Service implementation
- [/src/<ENTITY_SERVICE_NAME>.service.test.ts](mdc:src%2Fservice_name.service.test.ts) - Service unit tests
- [/src/<ENTITY_REPOSITORY_NAME>.repository.ts](mdc:src%2Frepository_name.repository.ts) - Repository implementation
- [/src/<ENTITY_REPOSITORY_NAME>.repository.test.ts](mdc:src%2Frepository_name
- [/src/<ENTITY>.types.ts](mdc:src%2Fddd.types.ts) - Domain entities, value objects, and types
