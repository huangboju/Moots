/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 */
import React, { Component } from 'react';
import {
  AppRegistry,
  Image,
  ListView,
  StyleSheet,
  Text,
  View,
} from 'react-native';

var REQUEST_URL = 'http://test.cmcaifu.com/api/v1/products/history/?page_size=10';

var Movie_Demo = React.createClass({
  getInitialState() {
    return {
      dataSource: new ListView.DataSource({
        rowHasChanged: (row1, row2) => row1 !== row2,
      }),
      loaded: false,
    };
  },

  componentDidMount() {
    this.fetchData();
  },

  fetchData() {
    fetch(REQUEST_URL)
      .then((response) => response.json())
      .then((responseData) => {
        this.setState({
          dataSource: this.state.dataSource.cloneWithRows(responseData.results),
          loaded: true,
        });
      })
      .done();
  },

  render() {
    if (!this.state.loaded) {
      return this.renderLoadingView();
    }

    return (
      <ListView
        dataSource={this.state.dataSource}
        renderRow={this.renderMovie}
        style={styles.listView}
      />
    );
  },

  renderLoadingView() {
    return (
      <View style={styles.container}>
        <Text>
          Loading movies...
        </Text>
      </View>
    );
  },

  renderMovie(movie) {
    return (
      <View>
        <View style={styles.container}>
          <View style={styles.rightContainer}>
            <Text style={styles.name}>{movie.name}</Text>
            <Text style={styles.inventory}>{movie.tags.count}</Text>
          </View>
        </View>
          <View style={styles.separator} />
      </View>
    );
  },
});

const styles = StyleSheet.create({
  container: {
    flex: 1,
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#DC143C',
  },
  rightContainer: {
    flex: 1,
    padding: 10,
  },
  separator: {
      height: 1,
      backgroundColor: '#DDDDDD',
  },
  title: {
    fontSize: 20,
    marginLeft: 10,
    textAlign: 'center',
  },
  inventory: {
    textAlign: 'right',
    width: 20,
    marginTop: -15,
    marginLeft: 280,
    backgroundColor: 'white',
  },
  listView: {
    paddingTop: 20,
    backgroundColor: '#F5FCFF',
  },
});

AppRegistry.registerComponent('Movie_Demo', () => Movie_Demo);
