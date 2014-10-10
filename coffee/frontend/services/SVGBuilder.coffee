
scorevision.service 'SVGBuilder', -> 
    return {
        createSVGLine: (x1, y1, x2, y2, width = 1, classname = '') ->
            line = document.createElementNS 'http://www.w3.org/2000/svg', 'line'
            line.setAttributeNS null, 'x1', x1
            line.setAttributeNS null, 'y1', y1
            line.setAttributeNS null, 'x2', x2
            line.setAttributeNS null, 'y2', y2
            line.setAttributeNS null, 'stroke-width', width
            line.setAttributeNS null, 'class', classname
            return line
        
        createSVGCircle: (cx, cy, r, classname) ->
            circle = document.createElementNS 'http://www.w3.org/2000/svg', 'circle'
            circle.setAttributeNS null, 'cx', cx
            circle.setAttributeNS null, 'cy', cy
            circle.setAttributeNS null, 'r', r
            circle.setAttributeNS null, 'class', 'team ' + classname
            return circle
        
        #Create rectangle centered on provided point
        createSVGRect: (x, y, width, height, classname) ->
            rect = document.createElementNS 'http://www.w3.org/2000/svg', 'rect'
            rect.setAttributeNS null, 'x', x - width/2
            rect.setAttributeNS null, 'y', y - height/2
            rect.setAttributeNS null, 'width', width
            rect.setAttributeNS null, 'height', height
            rect.setAttributeNS null, 'class', 'team ' + classname
            return rect
        
        #Create triangle centered on provided point
        createSVGTriangle: (x, y, width, height, classname) ->
            rect = document.createElementNS 'http://www.w3.org/2000/svg', 'polygon'
            rect.setAttributeNS null, 'points', (x-width/2) + ',' + (y+height/2) + ' ' + x + ',' + (y-height/2) + ' ' + (x+width/2) + ',' + (y+height/2)
            rect.setAttributeNS null, 'class', 'team ' + classname
            return rect
        
        createSVGPath: (pathString, classname) ->
            path = document.createElementNS 'http://www.w3.org/2000/svg', 'path'
            path.setAttributeNS null, 'd', pathString
            path.setAttributeNS null, 'class', 'team ' + classname
            path.setAttributeNS null, 'stroke-linecap', 'round'
            path.setAttributeNS null, 'stroke-linejoin', 'round'
            return path
        
        createSVGText: (content, anchor, x, y, classname = '') ->
            text = document.createElementNS 'http://www.w3.org/2000/svg', 'text'
            text.setAttributeNS null, 'class', 'team ' + classname
            text.setAttributeNS null, 'text-anchor', anchor
            text.setAttributeNS null, 'x', x
            text.setAttributeNS null, 'y', y + 2
            text.innerHTML = content
            return text
    }
    