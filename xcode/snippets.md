# Xcode Code Snippets

Quick reference for custom Xcode code snippets stored in this repository.

## Debugging Snippets

### print plain
- **Language**: Swift
- **Code**: `print("print[\(#function)]")`

### print
- **Language**: Swift  
- **Code**: `print("print[\(#function)] value: \(<#value#>)")`

### print memory address
- **Language**: Swift
- **Code**: `print("print[\(#function)] <#value#>: \(unsafeBitCast(<#value#>, to: UnsafeRawPointer.self))")`

## Code Organization

### mark
- **Language**: Swift
- **Code**: `// MARK: - `
- **Note**: Creates a commented out mark block

### mark plain
- **Language**: Swift
- **Code**: `// MARK: `

### note
- **Language**: Swift
- **Code**: `/// - NOTE: `

---
*Note: These snippets don't have completion prefixes set. Access them via Xcode's snippet menu or assign shortcuts manually.*