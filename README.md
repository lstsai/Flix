# Project 2 - *Flix*

**Flix** is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **10** hours spent in total

## User Stories

The following **required** functionality is complete:

- [x ] User sees an app icon on the home screen and a styled launch screen.
- [x ] User can view a list of movies currently playing in theaters from The Movie Database.
- [x ] Poster images are loaded using the UIImageView category in the AFNetworking library.
- [x ] User sees a loading state while waiting for the movies API.
- [x ] User can pull to refresh the movie list.
- [x ] User sees an error message when there's a networking error.
- [x] User can tap a tab bar button to view a grid layout of Movie Posters using a CollectionView.

The following **optional** features are implemented:

- [x ] User can tap a poster in the collection view to see a detail screen of that movie
- [x ] User can search for a movie.
- [ ] All images fade in as they are loading.
- [ ] User can view the large movie poster by tapping on a cell.
- [ ] For the large poster, load the low resolution image first and then switch to the high resolution image when complete.
- [ ] Customize the selection effect of the cell.
- [ ] Customize the navigation bar.
- [ ] Customize the UI.

The following **additional** features are implemented:

- [ ] List anything else that you can get done to improve the app functionality!

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1.
2.

## Video Walkthrough

Here's a walkthrough of implemented user stories:
### Stories 1, 2, 3, 4, 5, 7:

<img src='http://g.recordit.co/1gSc8DKZc2.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

### Stories 4, 6:

<img src='https://recordit.co/R5towMaaOh.gif' title='Video Walkthrough 2' width='' alt='Video Walkthrough 2' />

### Optional Stories: Search bar, Details view from collection view, Trailer from poster
<img src='https://recordit.co/gdZ9KZhBab.gif' title='Video Walkthrough 3' width='' alt='Video Walkthrough 3' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.
1. Learning how to extract data from JSON files, I was stuck on an error because I was treating the data like dictionary but it was actually an array containing one dictionary as it's element.
2. Learning about predicates to filter the data
3. Learning that not all views can be tapped on to be a segue, need tap gesture recognizer


## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library

## License

    Copyright [yyyy] [name of copyright owner]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
