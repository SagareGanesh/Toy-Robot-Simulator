Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'robots#dashboard', as: 'robots_dashboard'

  post 'robot/place' => 'robots#place', as: 'robots_place'
  put 'robot/rotate' => 'robots#rotate', as: 'robots_rotate'
  put 'robot/move' => 'robots#move', as: 'robots_move'
  get 'robot/report' => 'robots#report', as: 'robots_report'
end
