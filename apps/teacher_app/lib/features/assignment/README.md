# Assignment Feature

## Overview
The Assignment feature provides functionality to view and manage assignments in the teacher app. This feature has been cleaned up to remove unused code and follow clean architecture principles.

## Architecture

### Domain Layer
- **Entities**: `Assignment` with `AssignmentStatus` enum
- **Repositories**: `AssignmentRepository` interface
- **Use Cases**: `GetAssignmentsUseCase` for fetching assignments

### Data Layer
- **Models**: `AssignmentModel` with JSON serialization
- **Data Sources**: `AssignmentRemoteDataSource` with mock data
- **Repository Implementation**: `AssignmentRepositoryImpl`

### Presentation Layer
- **BLoC**: `AssignmentBloc` for state management
- **Events**: `LoadAssignments` for fetching assignments
- **States**: `AssignmentInitial`, `AssignmentLoading`, `AssignmentLoaded`, `AssignmentError`
- **UI Components**: Modular widgets for different states

## Features

### ✅ Implemented
- View assignments list with pull-to-refresh
- Search assignments by title/subtitle
- Filter assignments by status (All, Graded, Ungraded)
- Error handling with retry functionality
- Responsive design with proper spacing
- Clean separation of concerns

### 🗑️ Removed (Unused Code)
- `AddAssignment` functionality (moved to New Assignment feature)
- `AddAssignmentUseCase`
- `AddAssignment` event
- `addAssignment` methods in repository and data source
- Unnecessary validation and error simulation for add operations

## UI Components

### Pages
- `AssignmentsPage`: Main page with search, filter, and list

### Widgets
- `AssignmentsAppBar`: App bar with add button
- `AssignmentsSearchField`: Search input with debouncing
- `AssignmentsFilterChips`: Filter options (All, Graded, Ungraded)
- `AssignmentsList`: Scrollable list with pull-to-refresh
- `AssignmentsLoadingState`: Loading indicator
- `AssignmentsErrorState`: Error display with retry
- `AssignmentsEmptyState`: Empty state for no results
- `AssignmentListTile`: Individual assignment item

## Data Flow

1. **User Action**: Search, filter, or pull-to-refresh
2. **Event**: `LoadAssignments` with search/filter parameters
3. **Use Case**: `GetAssignmentsUseCase` calls repository
4. **Repository**: `AssignmentRepositoryImpl` calls data source
5. **Data Source**: `AssignmentRemoteDataSourceImpl` returns mock data
6. **State**: `AssignmentLoaded` or `AssignmentError`
7. **UI**: Updates to show results or error

## Mock Data

The feature uses mock data to simulate backend responses:
- 5 sample assignments with different statuses
- Random error simulation (10% chance)
- Proper JSON structure matching real API responses
- Search and filter functionality on mock data

## Error Handling

- **Network Errors**: Simulated with random failures
- **Data Parsing**: Proper null safety and type checking
- **User Feedback**: Clear error messages and retry options
- **Pull-to-Refresh**: Works in all states including error state

## Clean Code Principles

- **Single Responsibility**: Each widget has one clear purpose
- **Separation of Concerns**: UI, business logic, and data layers separated
- **DRY**: No code duplication
- **SOLID**: Proper interfaces and dependency injection
- **Maintainable**: Easy to modify and extend

## Future Enhancements

- Real backend integration
- Assignment details page
- Assignment editing functionality
- Bulk operations
- Advanced filtering options 