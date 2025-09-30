# Documentation Index

Welcome to the Electricity Tracker documentation! This page helps you find the right information quickly.

## 📚 Documentation Structure

### For Users

- **[User Guide](USER_GUIDE.md)** - Complete guide to using the app
  - Getting started
  - Creating houses and cycles
  - Recording consumption
  - Editing and managing data
  - Troubleshooting
  - FAQ

### For Developers

- **[Quick Reference](QUICK_REFERENCE.md)** - Quick lookup for common tasks

  - Project structure
  - Common commands
  - Code patterns
  - Shortcuts and snippets

- **[Architecture](ARCHITECTURE.md)** - Technical architecture deep-dive

  - Layer architecture
  - State management (Riverpod)
  - Database design (Drift)
  - Navigation (GoRouter)
  - Design patterns
  - Performance considerations

- **[Database Schema](DATABASE.md)** - Database structure and queries

  - Table definitions
  - Relationships
  - Common queries
  - Migrations
  - Soft delete pattern
  - Performance optimization

- **[Cycle Update & Recalculation](CYCLE_UPDATE_RECALCULATION.md)** - How cycle updates affect consumption data
  - Why recalculation is needed
  - What triggers recalculation
  - Implementation details
  - Example scenarios
  - Performance considerations

## 🎯 Find What You Need

### I want to...

**Use the app**

- [Get started with first setup](USER_GUIDE.md#getting-started)
- [Create a billing cycle](USER_GUIDE.md#creating-a-billing-cycle)
- [Record a meter reading](USER_GUIDE.md#recording-consumption)
- [Edit a cycle](USER_GUIDE.md#editing-a-cycle)
- [Troubleshoot issues](USER_GUIDE.md#troubleshooting)

**Understand the code**

- [See architecture overview](ARCHITECTURE.md#overview)
- [Learn about state management](ARCHITECTURE.md#2-state-management-riverpod)
- [Understand database design](DATABASE.md#database-structure)
- [Review navigation patterns](ARCHITECTURE.md#4-navigation-gorouter)

**Start developing**

- [Set up development environment](QUICK_REFERENCE.md#development)
- [Run the app locally](QUICK_REFERENCE.md#common-commands)
- [Understand project structure](QUICK_REFERENCE.md#project-structure)
- [Learn common patterns](QUICK_REFERENCE.md#common-patterns)

**Contribute**

- [Follow contribution guidelines](#contributing)
- [Understand coding standards](QUICK_REFERENCE.md#best-practices)
- [Run tests](QUICK_REFERENCE.md#common-commands)
- [Submit a pull request](#contributing)

## 📖 Documentation by Topic

### State Management

- [Riverpod providers overview](ARCHITECTURE.md#provider-types)
- [Provider patterns](ARCHITECTURE.md#2-provider-pattern-riverpod)
- [State flow diagram](ARCHITECTURE.md#state-flow)

### Database

- [Schema overview](DATABASE.md#database-structure)
- [Table definitions](DATABASE.md#table-definitions)
- [Query patterns](DATABASE.md#common-queries)
- [Migration guide](DATABASE.md#migrations)

### Navigation

- [Route structure](ARCHITECTURE.md#route-structure)
- [Navigation patterns](ARCHITECTURE.md#navigation-patterns)
- [Available routes](QUICK_REFERENCE.md#routes)

### UI/UX

- [Feature organization](ARCHITECTURE.md#1-presentation-layer)
- [Component architecture](ARCHITECTURE.md#key-principles)
- [Best practices](QUICK_REFERENCE.md#best-practices)

## 🚀 Quick Links

### Getting Started

- [Installation](../README.md#installation)
- [First run](USER_GUIDE.md#first-launch)
- [Create your first house](USER_GUIDE.md#creating-your-first-house)

### Development

- [Project structure](QUICK_REFERENCE.md#project-structure)
- [Development commands](QUICK_REFERENCE.md#common-commands)
- [Testing](ARCHITECTURE.md#testing-strategy)

### Reference

- [Providers](QUICK_REFERENCE.md#providers-quick-reference)
- [Database queries](DATABASE.md#common-queries)
- [Routes](QUICK_REFERENCE.md#routes)

## 🤝 Contributing

We welcome contributions! Here's how to get started:

1. **Read the documentation**

   - Review [Architecture](ARCHITECTURE.md) for design principles
   - Check [Quick Reference](QUICK_REFERENCE.md) for coding patterns
   - Understand [Database Schema](DATABASE.md) for data model

2. **Set up development environment**

   ```bash
   git clone https://github.com/sai-phaneesh/simple-electricity-tracker.git
   cd electricity
   flutter pub get
   flutter run
   ```

3. **Make your changes**

   - Follow [coding standards](QUICK_REFERENCE.md#best-practices)
   - Write tests for new features
   - Update documentation as needed

4. **Submit a pull request**
   - Use [conventional commits](QUICK_REFERENCE.md#commit-message-convention)
   - Describe your changes clearly
   - Reference related issues

## 📝 Documentation Guidelines

When updating documentation:

- **Keep it current**: Update docs when code changes
- **Be clear**: Use simple language and examples
- **Be thorough**: Include enough detail for understanding
- **Be concise**: Remove unnecessary information
- **Use diagrams**: Visual aids help explain concepts
- **Link related content**: Help readers find more information

## 🔍 Search Tips

- Use your editor's search (Cmd/Ctrl + F) to find keywords
- Check the table of contents in each document
- Use the "Find What You Need" section above
- Browse by topic in "Documentation by Topic"

## 📧 Need Help?

- **Found a bug?** [Open an issue](https://github.com/sai-phaneesh/simple-electricity-tracker/issues)
- **Have a question?** [Start a discussion](https://github.com/sai-phaneesh/simple-electricity-tracker/discussions)
- **Want to contribute?** See [Contributing](#contributing) above

## 📚 External Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
- [Drift Documentation](https://drift.simonbinder.eu/)
- [GoRouter Documentation](https://pub.dev/packages/go_router)
- [Material Design Guidelines](https://m3.material.io/)

---

**Last Updated**: September 2025  
**Version**: 1.0.0  
**Maintained by**: [sai-phaneesh](https://github.com/sai-phaneesh)
