# Union Shop - Project Criteria

## Progress Summary
**Completed**: 7/19 criteria (36.8%)
- Basic: 7/9 items (28%)
- Intermediate: 1/7 items (3%)
- Advanced: 0/3 items (0%)
- **Total Progress**: 31% of project complete

---

## Basic (40%)

### Static Homepage
- [x] Homepage layout and widgets with static content (hardcoded data acceptable, mobile view focus) - **5%** ✅
- Reference: Homepage
- **Tests:**
  - [ ] Homepage renders without errors
  - [ ] Hero section displays with image and text
  - [ ] Product grid displays 4 hardcoded products
  - [ ] All product cards are clickable
  - [ ] Layout is readable on mobile (< 600px width)

### About Us Page
- [x] Static about us page with company information (separate page from homepage) - **5%** ✅
- Reference: About Us
- **Tests:**
  - [x] About Us page accessible via `/about` route
  - [x] Page displays company information
  - [x] Page includes header and footer
  - [ ] Content is formatted properly
  - [ ] Navigation to/from page works

### Footer
- [x] Footer with dummy links and information present in at least one page - **4%** ✅
- Reference: Homepage
- **Tests:**
  - [x] Footer displays on at least one page
  - [x] Footer includes copyright information
  - [x] Footer includes opening hours
  - [x] Footer includes policy links (Privacy, Terms)
  - [x] Footer is responsive (mobile & desktop layouts)
  - [ ] Footer appears on all pages

### Collections Page (Dummy)
- [x] Page displaying various collections of products (hardcoded data acceptable) - **5%** ✅
- Reference: Collections
- **Tests:**
  - [x] Collections page accessible via `/collections` route
  - [x] Page displays at least 3 collections
  - [x] Each collection shows title, description, and image
  - [x] Each collection shows product count
  - [x] Collections are clickable
  - [x] Responsive grid layout (1/2/3 columns based on width)

### Collection Page (Dummy)
- [ ] Page displaying products within one collection including dropdowns and filters (hardcoded data acceptable, widgets do not have to function) - **5%**
- Reference: Collection Example
- **Tests:**
  - [ ] Collection detail page exists
  - [ ] Page displays products for a specific collection
  - [ ] Filter dropdowns are visible (sort by, price range, etc.)
  - [ ] Pagination controls are visible
  - [ ] Products display in grid layout
  - [ ] Widgets display properly (functionality not required)

### Product Page (Dummy)
- [x] Product page showing details and images with dropdowns, buttons, and widgets (hardcoded data acceptable, widgets do not have to function) - **4%** ✅
- Reference: Product Example
- **Tests:**
  - [x] Product page accessible via `/product` route
  - [x] Page displays product image
  - [x] Page displays product name and price
  - [x] Page displays product description
  - [ ] Size/quantity dropdowns are visible
  - [ ] "Add to Cart" button is visible
  - [ ] Related products section exists

### Sale Collection
- [ ] Page showing sale products with discounted prices and promotional messaging (hardcoded data acceptable, widgets do not have to function) - **4%**
- Reference: Sale Items
- **Tests:**
  - [ ] Sale page accessible via route
  - [ ] Page displays promotional banner
  - [ ] Products show original price (strikethrough)
  - [ ] Products show discounted price
  - [ ] Discount percentage is visible
  - [ ] At least 4 sale products displayed

### Authentication UI
- [x] Login/signup page with the relevant forms (widgets do not have to function) - **3%** ✅
- Reference: Sign In
- **Tests:**
  - [x] Login page accessible via `/auth` route
  - [x] Login form includes email field
  - [x] Login form includes password field
  - [x] Login form includes submit button
  - [x] Signup form exists (separate or toggle)
  - [x] "Forgot Password" link exists
  - [x] Forms are styled consistently
  - [x] Account icon in header navigates to auth page

### Static Navbar
- [x] Top navigation bar on desktop view (the links do not have to work, it should collapse to a menu button on mobile) - **5%** ✅
- Reference: Homepage
- **Tests:**
  - [x] Header displays on all pages
  - [x] Logo is visible and clickable (returns to home)
  - [x] Desktop nav shows links (Home, Shop, About, etc.)
  - [x] Shop button shows dropdown with collections
  - [x] Mobile view shows hamburger menu (< 600px)
  - [x] Mobile menu opens and shows navigation links
  - [x] Header includes search, account, cart icons

---

## Intermediate (35%)

### Dynamic Collections Page
- [ ] Collections page populated from data models or services with functioning sorting, filtering, pagination widgets - **6%**
- Reference: Collections
- **Tests:**
  - [ ] Collections loaded from data model/service (not hardcoded)
  - [ ] Sort dropdown functions (A-Z, popularity, etc.)
  - [ ] Filter checkboxes work (by category, price, etc.)
  - [ ] Pagination buttons navigate between pages
  - [ ] Current page indicator works
  - [ ] Collections update when filters change
  - [ ] Loading state displays while fetching data

### Dynamic Collection Page
- [ ] Product listings of a collection populated from data models or services with functioning sorting, filtering, pagination widgets - **6%**
- Reference: Collection Example
- **Tests:**
  - [ ] Products loaded from data model/service
  - [ ] URL parameter determines which collection to load
  - [ ] Sort dropdown changes product order
  - [ ] Price range filter works
  - [ ] Category filter works
  - [ ] Pagination displays correct products per page
  - [ ] Product count updates with filters
  - [ ] "Load More" or page navigation works

### Functional Product Pages
- [ ] Product pages populated from data models or services with functioning dropdowns and counters (add to cart buttons do not have to work yet) - **6%**
- Reference: Product Example
- **Tests:**
  - [ ] Product loaded from data model using route parameter
  - [ ] Size dropdown changes selected size
  - [ ] Color dropdown changes selected color
  - [ ] Quantity counter increments/decrements
  - [ ] Quantity counter prevents values < 1
  - [ ] Selected options display correctly
  - [ ] Product images can be changed/zoomed
  - [ ] Related products load dynamically

### Shopping Cart
- [ ] Add items to cart, view cart page, basic cart functionality (checkout buttons should place order without real monetary transactions) - **6%**
- Reference: Cart
- **Tests:**
  - [ ] "Add to Cart" button adds item to cart
  - [ ] Cart icon shows item count
  - [ ] Cart page displays all added items
  - [ ] Each cart item shows image, name, price, quantity
  - [ ] Subtotal calculates correctly
  - [ ] "Checkout" button places order
  - [ ] Order confirmation displays after checkout
  - [ ] Cart empties after successful checkout

### Print Shack
- [ ] Text personalisation page with associated about page, the form must dynamically update based on selected fields - **3%**
- Reference: Personalisation
- **Tests:**
  - [ ] Print Shack page accessible via route
  - [ ] Form includes text input fields
  - [ ] Form includes dropdown/radio options
  - [ ] Preview updates in real-time as user types
  - [ ] Font/color/size options change preview
  - [ ] About page for Print Shack exists
  - [ ] Navigation between personalisation and about works

### Navigation
- [x] Full navigation across all pages; users should be able to navigate using buttons, navbar, and URLs - **3%** ✅
- Reference: All pages
- **Tests:**
  - [x] All navbar links navigate to correct pages
  - [x] Direct URL navigation works for all routes
  - [x] Back button works correctly
  - [x] Breadcrumbs or path indicators exist
  - [x] 404 page handles invalid routes
  - [x] 404 page includes helpful navigation options
  - [ ] Deep linking works (e.g., `/product/123`)
  - [ ] Navigation state persists correctly

### Responsiveness
- [ ] The layout of the application should be adaptive, and the application should function on desktop in addition to mobile view (no need to test it on real devices) - **5%**
- Reference: All pages
- **Tests:**
  - [ ] All pages tested at mobile width (< 600px)
  - [ ] All pages tested at tablet width (600-900px)
  - [ ] All pages tested at desktop width (> 900px)
  - [ ] Images scale appropriately
  - [ ] Text remains readable at all sizes
  - [ ] Buttons/links remain clickable
  - [ ] No horizontal scrolling occurs
  - [ ] Grid layouts adjust column count
  - [ ] Touch targets are adequate on mobile

---

## Advanced (25%)

### Authentication System
- [ ] Full user authentication and account management (you can implement this with other authenticators like Google, or Facebook, not just Shop.app), includes the account dashboard and all relevant functionality - **8%**
- Reference: Account

### Cart Management
- [ ] Full cart functionality including quantity editing/removal, price calculations and persistence - **6%**
- Reference: Cart

### Search System
- [ ] Complete search functionality (search buttons should function on the navbar and the footer) - **4%**
- Reference: Search

---

## Summary

- **Basic**: 40% (9 criteria)
- **Intermediate**: 35% (7 criteria)
- **Advanced**: 25% (3 criteria)
- **Total**: 100% (19 criteria)

## Notes

- *Dummy/Static: Widgets and links do not need to be functional
- *Hardcoded data: Acceptable for basic/dummy implementations
- *Responsiveness: Must work on desktop and mobile views (no real device testing required)
