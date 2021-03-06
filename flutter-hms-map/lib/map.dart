/*
Copyright 2020. Huawei Technologies Co., Ltd. All rights reserved.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:huawei_map/constants/param.dart';
import 'package:huawei_map/channel/huaweiMapMethodChannel.dart';

import 'package:huawei_map/events/events.dart';
export 'package:huawei_map/events/events.dart';

import 'package:huawei_map/components/components.dart';
export 'package:huawei_map/components/components.dart';

final HuaweiMapMethodChannel mChannel = HuaweiMapMethodChannel.instance;

typedef void MapCreatedCallback(HuaweiMapController controller);

class HuaweiMapController {
  final int mapId;

  HuaweiMapController._(
    CameraPosition initialCameraPosition,
    this._huaweiMapState, {
    @required this.mapId,
  }) {
    _connectStreams(mapId);
  }

  static Future<HuaweiMapController> init(
    int id,
    CameraPosition initialCameraPosition,
    _HuaweiMapState huaweiMapState,
  ) async {
    await mChannel.init(id);
    return HuaweiMapController._(
      initialCameraPosition,
      huaweiMapState,
      mapId: id,
    );
  }

  final _HuaweiMapState _huaweiMapState;

  void _connectStreams(int mapId) {
    mChannel
        .onMarkerClick(mapId: mapId)
        .listen((MarkerClickEvent e) => _huaweiMapState.onMarkerClick(e.value));
    mChannel.onMarkerDragEnd(mapId: mapId).listen((MarkerDragEndEvent e) =>
        _huaweiMapState.onMarkerDragEnd(e.value, e.position));
    mChannel.onInfoWindowClick(mapId: mapId).listen(
        (InfoWindowClickEvent e) => _huaweiMapState.onInfoWindowClick(e.value));
    mChannel.onPolylineClick(mapId: mapId).listen(
        (PolylineClickEvent e) => _huaweiMapState.onPolylineClick(e.value));
    mChannel.onPolygonClick(mapId: mapId).listen(
        (PolygonClickEvent e) => _huaweiMapState.onPolygonClick(e.value));
    mChannel
        .onCircleClick(mapId: mapId)
        .listen((CircleClickEvent e) => _huaweiMapState.onCircleClick(e.value));
    mChannel
        .onClick(mapId: mapId)
        .listen((MapClickEvent e) => _huaweiMapState.onClick(e.position));
    mChannel.onLongPress(mapId: mapId).listen(
        (MapLongPressEvent e) => _huaweiMapState.onLongPress(e.position));
    if (_huaweiMapState.widget.onCameraMoveStarted != null) {
      mChannel
          .onCameraMoveStarted(mapId: mapId)
          .listen((_) => _huaweiMapState.widget.onCameraMoveStarted());
    }
    if (_huaweiMapState.widget.onCameraMove != null) {
      mChannel.onCameraMove(mapId: mapId).listen(
          (CameraMoveEvent e) => _huaweiMapState.widget.onCameraMove(e.value));
    }
    if (_huaweiMapState.widget.onCameraIdle != null) {
      mChannel
          .onCameraIdle(mapId: mapId)
          .listen((_) => _huaweiMapState.widget.onCameraIdle());
    }
  }

  Future<void> _updateMapOptions(Map<String, dynamic> optionsUpdate) {
    return mChannel.updateMapOptions(optionsUpdate, mapId: mapId);
  }

  Future<void> _updateMarkers(MarkerUpdates markerUpdates) {
    return mChannel.updateMarkers(markerUpdates, mapId: mapId);
  }

  Future<void> _updatePolygons(PolygonUpdates polygonUpdates) {
    return mChannel.updatePolygons(polygonUpdates, mapId: mapId);
  }

  Future<void> _updatePolylines(PolylineUpdates polylineUpdates) {
    return mChannel.updatePolylines(polylineUpdates, mapId: mapId);
  }

  Future<void> _updateCircles(CircleUpdates circleUpdates) {
    return mChannel.updateCircles(circleUpdates, mapId: mapId);
  }

  Future<void> animateCamera(CameraUpdate cameraUpdate) {
    return mChannel.animateCamera(cameraUpdate, mapId: mapId);
  }

  Future<void> moveCamera(CameraUpdate cameraUpdate) {
    return mChannel.moveCamera(cameraUpdate, mapId: mapId);
  }

  Future<void> setMapStyle(String mapStyle) {
    return mChannel.setMapStyle(mapStyle, mapId: mapId);
  }

  Future<LatLngBounds> getVisibleRegion() {
    return mChannel.getVisibleRegion(mapId: mapId);
  }

  Future<ScreenCoordinate> getScreenCoordinate(LatLng latLng) {
    return mChannel.getScreenCoordinate(latLng, mapId: mapId);
  }

  Future<LatLng> getLatLng(ScreenCoordinate screenCoordinate) {
    return mChannel.getLatLng(screenCoordinate, mapId: mapId);
  }

  Future<void> showMarkerInfoWindow(MarkerId markerId) {
    return mChannel.showMarkerInfoWindow(markerId, mapId: mapId);
  }

  Future<void> hideMarkerInfoWindow(MarkerId markerId) {
    return mChannel.hideMarkerInfoWindow(markerId, mapId: mapId);
  }

  Future<bool> isMarkerInfoWindowShown(MarkerId markerId) {
    return mChannel.isMarkerInfoWindowShown(markerId, mapId: mapId);
  }

  Future<double> getZoomLevel() {
    return mChannel.getZoomLevel(mapId: mapId);
  }

  Future<Uint8List> takeSnapshot() {
    return mChannel.takeSnapshot(mapId: mapId);
  }
}

class HuaweiMap extends StatefulWidget {
  final CameraPosition initialCameraPosition;
  final bool compassEnabled;
  final bool mapToolbarEnabled;
  final CameraTargetBounds cameraTargetBounds;
  final MapType mapType;
  final MinMaxZoomPreference minMaxZoomPreference;
  final bool rotateGesturesEnabled;
  final bool scrollGesturesEnabled;
  final bool zoomControlsEnabled;
  final bool zoomGesturesEnabled;
  final bool tiltGesturesEnabled;
  final EdgeInsets padding;
  final Set<Marker> markers;
  final Set<Polygon> polygons;
  final Set<Polyline> polylines;
  final Set<Circle> circles;
  final bool myLocationEnabled;
  final bool myLocationButtonEnabled;
  final bool trafficEnabled;
  final bool buildingsEnabled;

  final MapCreatedCallback onMapCreated;
  final VoidCallback onCameraMoveStarted;
  final CameraPositionCallback onCameraMove;
  final VoidCallback onCameraIdle;
  final ArgumentCallback<LatLng> onClick;
  final ArgumentCallback<LatLng> onLongPress;

  const HuaweiMap({
    Key key,
    @required this.initialCameraPosition,
    this.mapType = MapType.normal,
    this.gestureRecognizers,
    this.compassEnabled = true,
    this.mapToolbarEnabled = true,
    this.cameraTargetBounds = CameraTargetBounds.unbounded,
    this.minMaxZoomPreference = MinMaxZoomPreference.unbounded,
    this.rotateGesturesEnabled = true,
    this.scrollGesturesEnabled = true,
    this.zoomControlsEnabled = true,
    this.zoomGesturesEnabled = true,
    this.tiltGesturesEnabled = true,
    this.myLocationEnabled = false,
    this.myLocationButtonEnabled = true,
    this.padding = const EdgeInsets.all(0),
    this.trafficEnabled = false,
    this.buildingsEnabled = true,
    this.markers,
    this.polygons,
    this.polylines,
    this.circles,
    this.onMapCreated,
    this.onCameraMoveStarted,
    this.onCameraMove,
    this.onCameraIdle,
    this.onClick,
    this.onLongPress,
  }) : super(key: key);

  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;

  @override
  State createState() => _HuaweiMapState();
}

class _HuaweiMapState extends State<HuaweiMap> {
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};
  Map<PolygonId, Polygon> _polygons = <PolygonId, Polygon>{};
  Map<CircleId, Circle> _circles = <CircleId, Circle>{};
  HuaweiMapOptions _huaweiMapOptions;

  final Completer<HuaweiMapController> _controller =
      Completer<HuaweiMapController>();

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> creationParams = <String, dynamic>{
      Param.initialCameraPosition: widget.initialCameraPosition?.toMap(),
      Param.options: _huaweiMapOptions.toMap(),
      Param.markersToInsert: markerToList(widget.markers),
      Param.polylinesToInsert: polylineToList(widget.polylines),
      Param.polygonsToInsert: polygonToList(widget.polygons),
      Param.circlesToInsert: circleToList(widget.circles),
    };
    return mChannel.buildView(
      creationParams,
      widget.gestureRecognizers,
      onPlatformViewCreated,
    );
  }

  @override
  void initState() {
    super.initState();
    _huaweiMapOptions = HuaweiMapOptions.fromWidget(widget);
    _markers = markerToMap(widget.markers);
    _polylines = polylineToMap(widget.polylines);
    _polygons = polygonToMap(widget.polygons);
    _circles = circleToMap(widget.circles);
  }

  Future<void> onPlatformViewCreated(int id) async {
    final HuaweiMapController controller = await HuaweiMapController.init(
      id,
      widget.initialCameraPosition,
      this,
    );
    _controller.complete(controller);
    if (widget.onMapCreated != null) {
      widget.onMapCreated(controller);
    }
  }

  void _updateOptions() async {
    final HuaweiMapOptions newOptions = HuaweiMapOptions.fromWidget(widget);
    final Map<String, dynamic> updates =
        _huaweiMapOptions.updatesMap(newOptions);
    if (updates.isEmpty) {
      return;
    }
    final HuaweiMapController controller = await _controller.future;
    controller._updateMapOptions(updates);
    _huaweiMapOptions = newOptions;
  }

  @override
  void didUpdateWidget(HuaweiMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateOptions();
    _updateMarkers();
    _updatePolylines();
    _updatePolygons();
    _updateCircles();
  }

  void _updateMarkers() async {
    final HuaweiMapController controller = await _controller.future;
    controller._updateMarkers(
        MarkerUpdates.update(_markers.values.toSet(), widget.markers));
    _markers = markerToMap(widget.markers);
  }

  void _updatePolylines() async {
    final HuaweiMapController controller = await _controller.future;
    controller._updatePolylines(
        PolylineUpdates.update(_polylines.values.toSet(), widget.polylines));
    _polylines = polylineToMap(widget.polylines);
  }

  void _updatePolygons() async {
    final HuaweiMapController controller = await _controller.future;
    controller._updatePolygons(
        PolygonUpdates.update(_polygons.values.toSet(), widget.polygons));
    _polygons = polygonToMap(widget.polygons);
  }

  void _updateCircles() async {
    final HuaweiMapController controller = await _controller.future;
    controller._updateCircles(
        CircleUpdates.update(_circles.values.toSet(), widget.circles));
    _circles = circleToMap(widget.circles);
  }

  void onClick(LatLng position) {
    if (widget.onClick != null) widget.onClick(position);
  }

  void onLongPress(LatLng position) {
    if (widget.onLongPress != null) widget.onLongPress(position);
  }

  void onMarkerClick(MarkerId markerId) {
    if (_markers[markerId]?.onClick != null) _markers[markerId].onClick();
  }

  void onMarkerDragEnd(MarkerId markerId, LatLng position) {
    if (_markers[markerId]?.onDragEnd != null)
      _markers[markerId].onDragEnd(position);
  }

  void onPolygonClick(PolygonId polygonId) {
    _polygons[polygonId].onClick();
  }

  void onPolylineClick(PolylineId polylineId) {
    if (_polylines[polylineId]?.onClick != null)
      _polylines[polylineId].onClick();
  }

  void onCircleClick(CircleId circleId) {
    _circles[circleId].onClick();
  }

  void onInfoWindowClick(MarkerId markerId) {
    if (_markers[markerId]?.infoWindow?.onClick != null)
      _markers[markerId].infoWindow.onClick();
  }
}
