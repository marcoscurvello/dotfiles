# Xcode Code Snippets

Quick reference for custom Xcode code snippets stored in this repository.

## Debugging Snippets

### print plain
- **Language**: Swift
- **Code**: `print("print[\(#function)]")`

### print memory address
- **Language**: Swift
- **Code**: `print("print[\(#function)] <#value#>: \(unsafeBitCast(<#value#>, to: UnsafeRawPointer.self))")`

### print
- **Language**: Swift
- **Code**: `print("print[\(#function)] value: \(<#value#>)")`

## Code Organization

### mark plain
- **Language**: Swift
- **Code**: `// MARK: `

### note
- **Language**: Swift
- **Code**: `/// - NOTE: `

### mark
- **Language**: Swift
- **Code**: `// MARK: - `
- **Note**: Creaters a commented out mark block

---
*Note: Snippets without shortcuts can be accessed via Xcode's snippet menu.*
