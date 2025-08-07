# Core Data Setup Guide

## Step-by-Step Instructions to Create ProductEntity

### 1. Open Core Data Model
1. In Xcode, navigate to `TRU_Assignment.xcdatamodeld`
2. Click on `TRU_Assignment.xcdatamodel` to open the Core Data model editor

### 2. Add Entity
1. Click the "+" button at the bottom of the editor to add a new entity
2. Name the entity: `ProductEntity`
3. Make sure "Class" is set to `ProductEntity` (this should match our Swift class)

### 3. Add Attributes
Add the following attributes to the `ProductEntity`:

| Attribute Name | Type | Optional |
|----------------|------|----------|
| `id` | Integer 64 | ❌ No |
| `title` | String | ✅ Yes |
| `price` | Double | ❌ No |
| `productDescription` | String | ✅ Yes |
| `category` | String | ✅ Yes |
| `image` | String | ✅ Yes |
| `ratingRate` | Double | ❌ No |
| `ratingCount` | Integer 64 | ❌ No |
| `createdAt` | Date | ✅ Yes |

### 4. Configure Entity
1. Select the `ProductEntity` in the editor
2. In the Data Model Inspector (right panel):
   - Set "Class" to `ProductEntity`
   - Set "Codegen" to `Manual/None` (since we have custom Swift files)

### 5. Save and Build
1. Save the Core Data model (Cmd + S)
2. Build the project (Cmd + B) to ensure everything compiles

## Alternative: Quick Setup via Code

If you prefer, you can also create the Core Data model programmatically. Add this to your `AppDelegate.swift` in the `didFinishLaunchingWithOptions` method:

```swift
func setupCoreDataModel() {
    let model = NSManagedObjectModel()
    
    // Create ProductEntity
    let productEntity = NSEntityDescription()
    productEntity.name = "ProductEntity"
    productEntity.managedObjectClassName = "ProductEntity"
    
    // Add attributes
    let idAttribute = NSAttributeDescription()
    idAttribute.name = "id"
    idAttribute.attributeType = .integer64AttributeType
    idAttribute.isOptional = false
    
    let titleAttribute = NSAttributeDescription()
    titleAttribute.name = "title"
    titleAttribute.attributeType = .stringAttributeType
    titleAttribute.isOptional = true
    
    let priceAttribute = NSAttributeDescription()
    priceAttribute.name = "price"
    priceAttribute.attributeType = .doubleAttributeType
    priceAttribute.isOptional = false
    
    let descriptionAttribute = NSAttributeDescription()
    descriptionAttribute.name = "productDescription"
    descriptionAttribute.attributeType = .stringAttributeType
    descriptionAttribute.isOptional = true
    
    let categoryAttribute = NSAttributeDescription()
    categoryAttribute.name = "category"
    categoryAttribute.attributeType = .stringAttributeType
    categoryAttribute.isOptional = true
    
    let imageAttribute = NSAttributeDescription()
    imageAttribute.name = "image"
    imageAttribute.attributeType = .stringAttributeType
    imageAttribute.isOptional = true
    
    let ratingRateAttribute = NSAttributeDescription()
    ratingRateAttribute.name = "ratingRate"
    ratingRateAttribute.attributeType = .doubleAttributeType
    ratingRateAttribute.isOptional = false
    
    let ratingCountAttribute = NSAttributeDescription()
    ratingCountAttribute.name = "ratingCount"
    ratingCountAttribute.attributeType = .integer64AttributeType
    ratingCountAttribute.isOptional = false
    
    let createdAtAttribute = NSAttributeDescription()
    createdAtAttribute.name = "createdAt"
    createdAtAttribute.attributeType = .dateAttributeType
    createdAtAttribute.isOptional = true
    
    // Add attributes to entity
    productEntity.properties = [
        idAttribute, titleAttribute, priceAttribute, descriptionAttribute,
        categoryAttribute, imageAttribute, ratingRateAttribute, ratingCountAttribute, createdAtAttribute
    ]
    
    // Add entity to model
    model.entities = [productEntity]
    
    // Save model
    // Note: This is a simplified approach. In production, you'd want to use the visual editor.
}
```

## Verification

After setting up the Core Data model:

1. Run the app
2. Check the console for any Core Data related messages
3. The app should now work with offline storage

## Troubleshooting

If you still see the "NSFetchRequest could not locate an NSEntityDescription" error:

1. **Clean Build Folder**: Xcode → Product → Clean Build Folder
2. **Delete App**: Remove the app from simulator/device and reinstall
3. **Check Entity Name**: Ensure the entity name in Core Data model exactly matches "ProductEntity"
4. **Check Class Name**: Ensure the class name in Core Data model is set to "ProductEntity"

## Current Status

The app is currently configured to work with an in-memory cache as a fallback while you set up Core Data. Once you create the `ProductEntity` in the Core Data model, the app will automatically switch to using Core Data for persistent storage. 