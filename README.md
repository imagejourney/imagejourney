# Final Project: Image Journey
James Man, Kim Toy, Sophia Feng

### Project Summary
ImageJourney is an iOS journaling app that makes it easy for you to document and share your travel adventures. For every journey that you take, you can create a new travel journal and add entries for each place that you visit, using photos, text, location, weather, and time to uniquely describe your experience. With ImageJourney, you can preserve your travel memories in a detailed and beautiful format and share it to help others get inspiration from journeys to plan their own trips. 

### Wireframes
<img src='/project_planning/wireframes-pt1.jpg?raw=true' title='Wireframes pt1' width='' alt='Wireframes pt1' />
<img src='/project_planning/wireframes-pt2.jpg?raw=true' title='Wireframes pt2' width='' alt='Wireframes pt2' />

### User Stories
- [ ] Login View
  - [ ] User who has account can login using email and password
  - [ ] Upon login, user is redirected to homefeed page
  - [ ] Error shown if login fails
  - [ ] **(Optional) User can login through Facebook**
  - [ ] **(Optional) User can login through Google**

- [ ] Sign up View
  - [ ] User can create an account, given a name, username, email, and password
  - [ ] User will be redirected to homefeed page after signing up
  - [ ] **(Optional) User must enter a valid email format**

- [ ] Homefeed View
  - [ ] Has option to create a new journal. This will open the compose journal view modally. 
  - [ ] Displays a feed with the five most recent journals by you and your friends using a table view. The homefeed journal cell should show the title, author, and a picture from one of the journal entries, unless the journal has no entries yet. 
  - [ ] Tapping on a journal cell should open the journal view. 
  - [ ] **(Optional) Load more journals as the user scrolls**
  - [ ] **(Optional) Sample multiple photos from journal entries to show in the homefeed journal cell.**
  - [ ] **(Optional) Optimized the images to show in a grid view or carousel.**

- [ ] Journal View
  - [ ] Shows title of the journal
  - [ ] Has a map icon/button. Tapping on this will take the user to the journal map view
  - [ ] Has a table view that displays all of the journal entries. An entry cell should be able to display a time, date, day of the week, location, weather, images, and text, if the information was provided by the user. 
  - [ ] Tapping on the entry cell should take the user to the journal entry close-up view. 
  - [ ] Should have navigation option to go back to the previous view (this should either be the profile view or homefeed view) and option to edit if the user is the journal owner. 
  
  - [ ] **(Optional) Times are localized for the location of the journal entry.**
  - [ ] **(Optional) The text in the entry view should be cut off at a certain number of lines, instead of displaying the full description.**
  - [ ] **(Optional) The entry cell can display multiple images optimized in a grid view or carousel. (The basic version would only need to display stacked images)**

- [ ]  Journal Entry Close-up View
  - [ ] Should display a time, date, day of the week, location, weather, images, and text, if the information was provided by the user. 
  - [ ] Navigation should have option to go back to the previous view. 
  - [ ] Tapping on an image should show it in an expanded view with a navigation option to go back to the previous view. 
  - [ ] **(Optional) The entry cell can display multiple images optimized in a grid view or carousel. (The basic version would only need to display stacked images)**

- [ ] Journal Map View
  - [ ] Shows a map view with pins showing all the locations in the journal entries. 
  - [ ] Tapping on a pin opens a small dialog showing the entry location and timestamp
  - [ ] **(Optional) Times are localized for the location of the journal entry.**
  - [ ] **(Optional) The pins should show a connected travel path, given the chronological order of the entries**

- [ ] Compose Journal View
  - [ ] Should have navigation bar with the options to cancel or save
  - [ ] Has input for journal title
  - [ ] Has button to add new entry. This will add a new entry form section, which contains: input for time and date, input for location, input for weather, option to add photos, and text field for a description. 
  - [ ] **(Optional) Time and date input opens calendar and time picker.**
  - [ ] **(Optional) Input for location has autocomplete options**
  - [ ] **(Optional) Input for weather displays different weather options as icons to choose from.**
  - [ ] **(Optional) User can choose whether journal is public of private. If private, can share with friends.**
  - [ ] **(Optional) User can use photos from facebook.**
  - [ ] **(Optional) User can use photos from google photos**

- [ ] Profile View
  - [ ] Displays user’s name and basic stats (# journals, # friends)
  - [ ] Displays a profile image. This can be changed by tapping on the icon and uploading a new photo. 
  - [ ] Shows a feed of the user’s most recent journal (see homefeed view for similar requirements)

- [ ] Friends View
  - [ ] Has option to add new friend using search tool, by username or full name
  - [ ] Shows list of friends (displays full name and username)
  - [ ] Tapping on a friend opens their profile view
  - [ ] **(Optional) Has a map icon. Tapping it will bring the user to a map view that contains pins of all his/her own travel locations + friends’ locations. Tapping on each pin brings up the user’s name and the location name. Pins can be differently colored for each user.**
  - [ ] **(Optional) Implement alphabetic scroll bar, like in the ios contacts app**

- [ ] Search View
  - [ ] Has search bar. Query will display top five results for journal locations and top five results for journal names. 
  - [ ] Has filter options: sort by recent, friends+user only
  - [ ] **(Optional) User can click “show more” to show more results for either search bucket.**

- [ ] Hamburger menu
  - [ ] Shows options for search, most recent journal, profile page, friends page, or logout
  - [ ] Hamburger menu should be available from all views, except signup and login
  - [ ] Most recent journal option should take user to their most recently created journal, given the timestamp of the latest entry in the journal. 
