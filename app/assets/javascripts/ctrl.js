/*globals angular, ActionCable*/

angular.module('app').controller('ctrl', function ($scope) {
  'use strict';

  $scope.connect = function () {
    var App = {};
    document.cookie = "id=" + $scope.id;
    console.log($scope.room);
    App.cable = ActionCable.createConsumer("ws://localhost:3000/cable");

    $scope.group = App.cable.subscriptions.create({ channel: "ChatChannel", group: $scope.room }, {
      received: function (data) {
        console.log(data);
      },
      connected: function () {
        $scope.status = "connected";
      },
      disconnected: function () {
        $scope.status = "disconnected";
      },
      rejected: function () {
        $scope.status = "rejected";
      },
      custom: function () {
        $scope.status = "custom";
      }
    }
      );

    $scope.private = App.cable.subscriptions.create("PrivateChannel", {
      received: function (data) {
        console.log(data);
      },
      connected: function () {
        $scope.status = "connected";
      },
      disconnected: function () {
        $scope.status = "disconnected";
      },
      rejected: function () {
        $scope.status = "rejected";
      },
      custom: function () {
        $scope.status = "custom";
      }
    }
      );
  };

  $scope.send = function () {
    if ($scope.to !== undefined && $scope.to > 0) {
      $scope.private.send({ to: $scope.to, body: $scope.msg });
    } else {
      $scope.group.send({ room: $scope.room, body: $scope.msg });
    }
  };
});