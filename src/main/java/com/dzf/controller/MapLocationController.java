package com.dzf.controller;

import com.dzf.pojo.Location;
import com.dzf.service.MapLocationservice;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/map")
public class MapLocationController {

    @Autowired
    private MapLocationservice mapLocationservice;

    @RequestMapping(value = "/storelocation",method = RequestMethod.POST)
    public void storeLocation(@RequestBody Location location){

        mapLocationservice.storeLocation(location);

        return;
    }

    @RequestMapping(value = "/storelocationinrange",method = RequestMethod.POST)
    public void storelocationinrange(@RequestBody Location location){

        System.out.println(location);
        System.out.println(location.getUserID());

        mapLocationservice.deletelocations();
        mapLocationservice.storelocationinrange(location);

        return;
    }

    @RequestMapping("/search")
    @ResponseBody
    public List<Location> showOtherLocations(@Param("id") Integer id){

        List<Location> locations = mapLocationservice.showOtherLocations(id);

        return locations;
    }

}
