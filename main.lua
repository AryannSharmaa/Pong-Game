push=require 'push'
Class=require 'class'

require 'Paddle'
require 'Ball'

WINDOW_HEIGHT=720
WINDOW_WIDTH=1280

VIRTUAL_HEIGHT=243
VIRTUAL_WIDTH=432

PADDLE_SPEED=200


function love.load()
    love.graphics.setDefaultFilter('nearest','nearest')
    love.window.setTitle("Pong")
    math.randomseed(os.time())

    smallFont=love.graphics.newFont('font.ttf',8)

    scoreFont=love.graphics.newFont('font.ttf',32)

    love.graphics.setFont(smallFont)

    sounds={
        ['paddle_hit']=love.audio.newSource('sounds/paddle_hit.wav','static'),
        ['score']=love.audio.newSource('sounds/score.wav','static'),
        ['wall_hit']=love.audio.newSource('sounds/wall_hit.wav','static')
    }

    push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT,{
        fullscreen=false,
        resizable=false,
        vsync=true
    })

    player1Score=0
    player2Score=0

    player1=Paddle(10,30,5,20)
    player2=Paddle(VIRTUAL_WIDTH-10,VIRTUAL_HEIGHT-30,5,20)

    ball=Ball(VIRTUAL_WIDTH/2-2,VIRTUAL_HEIGHT/2-2,4,4)


    gameState='start'
end


function love.update(dt)
    
    if tostring(player1Score)=='5' or tostring(player2Score)=='5' then
        gameState='end'
    end

    if gameState =='serve' then
        ball:reset()
    end


    if gameState=='play' then

        if ball:collides(player1) then
            ball.dx=-ball.dx*1.05
            


            if ball.dy <0 then
                ball.dy=-math.random(10,150)
            else
                ball.dy=math.random(10,150)
            end
            sounds['paddle_hit']:play()
        end
        if ball:collides(player2) then
            ball.dx=-ball.dx*1.05
            


            if ball.dy <0 then
                ball.dy=-math.random(10,150)
            else
                ball.dy=math.random(10,150)
            end
            sounds['paddle_hit']:play()
        end

        if ball.y<=0 then
            ball.y=0
            ball.dy=-ball.dy
            sounds['wall_hit']:play()
        end

        if ball.y>=VIRTUAL_HEIGHT-4 then
            ball.y=VIRTUAL_HEIGHT-4
            ball.dy=-ball.dy
            sounds['wall_hit']:play()
        end

        if ball.x>VIRTUAL_WIDTH then
            player1Score=player1Score+1
            sounds['score']:play()
            ball:reset()
            gameState='serve'
        end

        if ball.x<0 then
            player2Score=player2Score+1
            sounds['score']:play()
            ball:reset()
            gameState='serve'
        end

        if love.keyboard.isDown('w') then
            player1.dy=-PADDLE_SPEED
        elseif love.keyboard.isDown('s') then
            player1.dy=PADDLE_SPEED
        else
            player1.dy=0
        end

        if love.keyboard.isDown("up") then
            player2.dy=-PADDLE_SPEED
        elseif love.keyboard.isDown('down') then
            player2.dy=PADDLE_SPEED
        else
            player2.dy=0
        end

        if gameState=='play' then
            ball:update(dt)
        end
        player1:update(dt)
        player2:update(dt)
    end

end



function love.keypressed(key)

    if key=='escape' then
        love.event.quit()

    elseif key=='enter' or key =='return' then
        if gameState=='start' then
            gameState='serve'
        elseif gameState=='serve' then
            gameState='play'
        elseif gameState=='end' then
            gameState='serve'
            ball:reset()
            player1Score=0
            player2Score=0
        else
            gameState='serve'

            ball:reset()
        end
    end
end

function love.draw()
    push:apply('start')

    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    love.graphics.setFont(smallFont)
    if gameState=='start' then
        love.graphics.printf(
        'Start Pong!',
        0,
        20,
        VIRTUAL_WIDTH,
        'center')
        love.graphics.setFont(scoreFont)
        love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, 
    VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30,
    VIRTUAL_HEIGHT / 3)
    
    
    end
    
    if gameState=='serve' then
        love.graphics.printf('Serve',0,20,VIRTUAL_WIDTH,'center')
        love.graphics.setFont(scoreFont)
        love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, 
    VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30,
    VIRTUAL_HEIGHT / 3)
    end

    if gameState=='end' then
        if tostring(player1Score)=='5' then
            
            love.graphics.printf("P1 Won",0,20,VIRTUAL_WIDTH,'center')
        elseif tostring(player2Score)=='5' then
            love.graphics.printf("P2 Won",0,20,VIRTUAL_WIDTH,'center')
        end
        love.graphics.printf("Press Enter to restart",0,40,VIRTUAL_WIDTH,'center')
        love.graphics.setFont(scoreFont)
        love.graphics.setFont(scoreFont)
        love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, 
    VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30,
    VIRTUAL_HEIGHT / 3)
    end
    
    player1:render()
    player2:render()

    ball:render()

    displayFPS()
    

    push:apply('end')
end

function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0,255/255,0,255/255)
    love.graphics.print('FPS: ' ..tostring(love.timer.getFPS()),10,10)
end