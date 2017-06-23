import FluentProvider
import PostgreSQLProvider

extension Config {
    public func setup() throws {
        // allow fuzzy conversions for these types
        // (add your own types here)
        Node.fuzzy = [Row.self, JSON.self, Node.self]

        try setupLogging()
        try setupProviders()
        try setupPreparations()
    }
    
    // Set Logger
    private func setupLogging() throws {
        addConfigurable(log: { _ in
            return AllCapsLogger(exclamationCount: 5)
        }, name: "all-caps")
    }
    
    /// Configure providers
    private func setupProviders() throws {
        try addProvider(PostgreSQLProvider.Provider.self)
    }
    
    /// Add all models that should have their
    /// schemas prepared before the app boots
    private func setupPreparations() throws {
        preparations.append(Feedback.self)
        preparations.append(Project.self)
    }
}
