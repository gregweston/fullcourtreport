#   Copyright (C) 2014 Greg Weston
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#   GNU General Public License for more details.
#   You should have received a copy of the GNU General Public License
#   along with this program. If not, see <http://www.gnu.org/licenses/>.

fullcourt.service 'SVGBuilder', ->
    svg_ns = 'http://www.w3.org/2000/svg'
    return {
        createSVGLine: (x1, y1, x2, y2, width = 1, classname = '') ->
            line = document.createElementNS svg_ns, 'line'
            line.setAttributeNS null, 'x1', x1
            line.setAttributeNS null, 'y1', y1
            line.setAttributeNS null, 'x2', x2
            line.setAttributeNS null, 'y2', y2
            line.setAttributeNS null, 'stroke-width', width
            line.setAttributeNS null, 'class', classname
            return line
        
        createSVGCircle: (cx, cy, r, classname) ->
            circle = document.createElementNS svg_ns, 'circle'
            circle.setAttributeNS null, 'cx', cx
            circle.setAttributeNS null, 'cy', cy
            circle.setAttributeNS null, 'r', r
            circle.setAttributeNS null, 'class', 'team ' + classname
            return circle
        
        #Create rectangle centered on provided point
        createSVGRect: (x, y, width, height, classname) ->
            rect = document.createElementNS svg_ns, 'rect'
            rect.setAttributeNS null, 'x', x - width/2
            rect.setAttributeNS null, 'y', y - height/2
            rect.setAttributeNS null, 'width', width
            rect.setAttributeNS null, 'height', height
            rect.setAttributeNS null, 'class', 'team ' + classname
            return rect
        
        #Create triangle centered on provided point
        createSVGTriangle: (x, y, width, height, classname) ->
            rect = document.createElementNS svg_ns, 'polygon'
            rect.setAttributeNS null, 'points', (x-width/2) + ',' + (y+height/2) + ' ' + x + ',' + (y-height/2) + ' ' + (x+width/2) + ',' + (y+height/2)
            rect.setAttributeNS null, 'class', 'team ' + classname
            return rect
        
        createSVGPath: (pathString, classname) ->
            path = document.createElementNS svg_ns, 'path'
            path.setAttributeNS null, 'd', pathString
            path.setAttributeNS null, 'class', 'team ' + classname
            path.setAttributeNS null, 'stroke-linecap', 'round'
            path.setAttributeNS null, 'stroke-linejoin', 'round'
            return path
        
        createSVGText: (content, anchor, x, y, classname = '', transform = '') ->
            text = document.createElementNS svg_ns, 'text'
            text.setAttributeNS null, 'class', 'team ' + classname
            text.setAttributeNS null, 'text-anchor', anchor
            text.setAttributeNS null, 'x', x
            text.setAttributeNS null, 'y', y + 2
            text.setAttributeNS(null, 'transform', transform) if transform?
            text.innerHTML = content
            return text
    }
    